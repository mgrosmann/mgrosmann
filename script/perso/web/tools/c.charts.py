import sqlite3
from datetime import datetime, timedelta
from collections import defaultdict

def get_date_range(choice):
    # Base fixe : Lundi 2 mars 2026
    base_monday = datetime(2026, 3, 2)
    
    if choice in ['1', '2', '3', '4']:
        start = base_monday + timedelta(weeks=int(choice)-1)
        end = start + timedelta(days=7)
        label = f"SEMAINE {choice} ({start.strftime('%d/%m')} au {(end - timedelta(seconds=1)).strftime('%d/%m')})"
        return start.timestamp(), end.timestamp(), label
    elif choice.lower() == 'm':
        start = datetime(2026, 3, 1)
        end = datetime(2026, 4, 1)
        label = "MOIS DE MARS 2026"
        return start.timestamp(), end.timestamp(), label
    return None, None, None

def clean(text):
    """Nettoie les guillemets, espaces et uniformise la casse."""
    if not text: return ""
    return text.strip().strip("'").strip('"')

def generate_charts():
    print("\n--- 📊 GÉNÉRATEUR DE CHARTS (Version Corrigée) ---")
    print("1-4 : Choisir une semaine précise")
    print("M   : Bilan complet du mois (Mars)")
    choice = input("Votre choix : ").strip()

    ts_start, ts_end, label = get_date_range(choice)
    if not ts_start:
        print("❌ Choix invalide.")
        return

    conn = sqlite3.connect("/mnt/c/Partage/web/matheofm.db")
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    query = """
        SELECT m.artists, m.main_artist, m.album, m.track
        FROM scrobbles s
        JOIN metadata_ref m ON s.track_id = m.track_id
        WHERE s.timestamp >= ? AND s.timestamp < ?
    """
    cursor.execute(query, (ts_start, ts_end))
    rows = cursor.fetchall()

    if not rows:
        print(f"🏠 Aucun scrobble trouvé pour {label}.")
        conn.close()
        return

    artists_count = defaultdict(int)
    albums_count = defaultdict(int)
    tracks_count = defaultdict(int)

    for r in rows:
        # --- 1. ARTISTES (Nettoyage des doublons & Feats) ---
        raw_artists = r['artists'] if r['artists'] else r['main_artist']
        # On split, on nettoie chaque nom, et on met en Title Case pour fusionner 'Sdm' et 'SDM'
        individual_artists = [clean(a).title() for a in raw_artists.split(';')]
        
        for artist in individual_artists:
            if artist:
                artists_count[artist] += 1
        
        # --- 2. ALBUMS ---
        main_artist_clean = clean(r['main_artist']).title()
        album_name_clean = clean(r['album'])
        album_key = f"{main_artist_clean} - {album_name_clean}"
        albums_count[album_key] += 1
        
        # --- 3. TITRES (Inclusion des invités dans le nom) ---
        track_name_clean = clean(r['track'])
        # On identifie les guests (tous les artistes sauf le main_artist)
        guests = [a for a in individual_artists if a.lower() != main_artist_clean.lower()]
        
        if guests:
            guest_str = f" (ft. {', '.join(guests)})"
            track_display = f"{main_artist_clean} - {track_name_clean}{guest_str}"
        else:
            track_display = f"{main_artist_clean} - {track_name_clean}"
            
        tracks_count[track_display] += 1

    # Tris
    top_artists = sorted(artists_count.items(), key=lambda x: x[1], reverse=True)[:15]
    top_albums = sorted(albums_count.items(), key=lambda x: x[1], reverse=True)[:15]
    top_tracks = sorted(tracks_count.items(), key=lambda x: x[1], reverse=True)[:15]

    # --- AFFICHAGE ---
    print(f"\n🏆 CLASSEMENT : {label}")
    print("=" * 80)

    print(f"\n🎤 TOP 15 ARTISTES")
    print("-" * 80)
    for i, (name, count) in enumerate(top_artists, 1):
        bar = "█" * (count // 10) # 1 bloc = 10 écoutes pour rester lisible sur les gros scores
        print(f"#{i:<2} {name:<30} | {count:>4} écoutes  {bar}")

    print(f"\n💿 TOP 15 ALBUMS")
    print("-" * 80)
    for i, (name, count) in enumerate(top_albums, 1):
        print(f"#{i:<2} {name[:55]:<55} | {count:>4} écoutes")

    print(f"\n🎵 TOP 15 TITRES")
    print("-" * 80)
    for i, (name, count) in enumerate(top_tracks, 1):
        print(f"#{i:<2} {name[:55]:<55} | {count:>4} écoutes")

    print("\n" + "=" * 80)
    print(f"📈 TOTAL DE LA PÉRIODE : {len(rows)} scrobbles")
    conn.close()

if __name__ == "__main__":
    generate_charts()
