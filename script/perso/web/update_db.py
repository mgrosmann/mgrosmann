import sqlite3
import json
import os
import time
from refresh import refresh_scrobbles
from purge_total import purge  # <--- On importe la fonction de nettoyage
from sql import apply_fusion, normalize_for_key, format_quoted, clean_text_from_feats
from key import generate_key, get_main_artist# Dans update_db.py
# ... tes imports ...
from refresh import refresh_scrobbles
from purge_total import purge  # <--- Change 'super_clean' par 'purge'

def update_database():
    # 1. Récupération
    print("--- 🔄 Étape 1 : Récupération des nouveaux morceaux ---")
    refresh_scrobbles()

    # --- AJOUTE CETTE ÉTAPE ICI ---
    print("--- 🧹 Étape 1.5 : Purge des doublons ---")
    purge() 
    # ------------------------------

    # 2. Charger le JSON (maintenant il sera propre !)
    FILENAME = "scrobbles.json"
    # 3. Charger le JSON nettoyé
    FILENAME = "scrobbles.json"
    if not os.path.exists(FILENAME):
        print("❌ Erreur : scrobbles.json introuvable.")
        return

    with open(FILENAME, "r", encoding="utf-8") as f:
        all_data = json.load(f)

    # 4. Connexion DB
    conn = sqlite3.connect('matheofm.db')
    cursor = conn.cursor()

    # On récupère le timestamp le plus haut dans la DB
    cursor.execute("SELECT MAX(timestamp) FROM scrobbles")
    row = cursor.fetchone()
    last_db_ts = row[0] if row and row[0] else 0
    
    # 5. Filtrer uniquement ce qui est PLUS RÉCENT que la DB
    new_tracks = [t for t in all_data if t.get('timestamp', 0) > last_db_ts]

    if not new_tracks:
        print("✅ La base de données est déjà à jour (après purge).")
        conn.close()
        return

    print(f"--- 🏗️ Étape 3 : Préparation de l'insertion de {len(new_tracks)} morceaux ---")

    scrobbles_rows = []
    metadata_dict = {} # On utilise un dict pour gérer la priorité au plus long ici aussi

    for i in new_tracks:
        raw_t = i.get('track', '')
        raw_a = i.get('album', '')
        raw_r = i.get('artist', '')
        ts = i.get('timestamp')

        # Logique de nettoyage identique à ton sql.py
        track_name_clean = apply_fusion(raw_t.split('(')[0].split('feat')[0].split('Feat')[0])
        album_clean = apply_fusion(raw_a)
        #if album_clean.lower().endswith('gangx'):
            #album_clean = album_clean[:-1].strip()

        first_artist_raw = clean_text_from_feats(raw_r).split(';')[0]
        main_art_clean = apply_fusion(first_artist_raw)

        combined_raw = f"{raw_r};{raw_t}"
        all_parts = clean_text_from_feats(combined_raw).split(';')
        unique_arts = []
        for art in all_parts:
            f = apply_fusion(art)
            if f and f not in unique_arts and f.lower() not in [track_name_clean.lower(), album_clean.lower()]:
                unique_arts.append(f)
        final_artists_str = ";".join(unique_arts)

        # Clés
        tid = generate_key(f"{normalize_for_key(main_art_clean)}{normalize_for_key(album_clean)}{normalize_for_key(track_name_clean)}")
        alid = generate_key(f"{normalize_for_key(main_art_clean)}{normalize_for_key(album_clean)}")
        arid = generate_key(normalize_for_key(main_art_clean))

        # On ajoute aux scrobbles
        scrobbles_rows.append((
            format_quoted(main_art_clean),
            format_quoted(final_artists_str),
            format_quoted(album_clean),
            format_quoted(track_name_clean),
            ts, tid, alid, arid
        ))

        # Logique de mise à jour Metadata : On garde la version la plus longue pour le track_id
        if tid not in metadata_dict:
            metadata_dict[tid] = (main_art_clean, final_artists_str, album_clean, track_name_clean)
        else:
            if len(final_artists_str) > len(metadata_dict[tid][1]):
                metadata_dict[tid] = (main_art_clean, final_artists_str, album_clean, track_name_clean)

    # 6. Exécution SQL
    try:
        # Insertion des scrobbles
        cursor.executemany("INSERT INTO scrobbles VALUES (?, ?, ?, ?, ?, ?, ?, ?)", scrobbles_rows)
        
        # Insertion/Mise à jour des Metadata
        for tid, v in metadata_dict.items():
            cursor.execute("""
                INSERT INTO metadata_ref (track_id, main_artist, artists, album, track) 
                VALUES (?, ?, ?, ?, ?)
                ON CONFLICT(track_id) DO UPDATE SET
                artists = CASE WHEN length(?) > length(artists) THEN ? ELSE artists END
            """, (tid, format_quoted(v[0]), format_quoted(v[1]), format_quoted(v[2]), format_quoted(v[3]), format_quoted(v[1]), format_quoted(v[1])))
        
        conn.commit()
        print(f"✨ Terminé : {len(scrobbles_rows)} nouveaux scrobbles ajoutés proprement.")
    except Exception as e:
        print(f"❌ Erreur SQL : {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == "__main__":
    update_database()
