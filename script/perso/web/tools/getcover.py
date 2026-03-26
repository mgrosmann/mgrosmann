import sqlite3
import requests
import time
import hashlib
import re
import unicodedata

# --- CONFIGURATION ---
DB_NAME = "/mnt/c/Partage/web/matheofm.db"
LASTFM_API_KEY = "26efc00d7f356323fd26b088e0d21a3b"
USER_AGENT = "MatheoFM_Image_Fetcher/1.0"

def normalize_for_key(text):
    """Normalisation identique à celle utilisée dans ton week_core.py"""
    if not text: return ""
    text = "".join([c for c in unicodedata.normalize('NFKD', str(text)) if not unicodedata.combining(c)])
    return re.sub(r'[^a-z0-9]', '', text.lower())

def get_album_id(artist, album):
    """Génère l'ID (MD5) utilisé pour la table library type 2"""
    # On suit la logique de tes autres fichiers : clean_artist + clean_album
    clean = normalize_for_key(artist) + normalize_for_key(album)
    return hashlib.md5(clean.encode('utf-8')).hexdigest()

def fetch_album_art(artist, album):
    """Appelle l'API Last.fm pour récupérer l'URL de l'image de l'album"""
    url = "http://ws.audioscrobbler.com/2.0/"
    params = {
        "method": "album.getInfo",
        "api_key": LASTFM_API_KEY,
        "artist": artist,
        "album": album,
        "format": "json"
    }
    headers = {'User-Agent': USER_AGENT}

    try:
        response = requests.get(url, params=params, headers=headers)
        data = response.json()
        
        if "album" in data and "image" in data["album"]:
            # Last.fm renvoie plusieurs tailles, on prend la plus grande ('extralarge' ou 'large')
            images = data["album"]["image"]
            # On cherche l'image 'extralarge', sinon la dernière disponible
            img_url = images[-1]["#text"]
            return img_url
    except Exception as e:
        print(f"Erreur API pour {artist} - {album}: {e}")
    
    return None

def main():
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()

    # 1. Création de la table si elle n'existe pas
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS library (
            id TEXT PRIMARY KEY, 
            url TEXT, 
            type INTEGER
        )
    """)

    # 2. Récupération des couples Artiste/Album distincts
    # On ignore les albums vides (comme ton exemple Booba|'')
    cursor.execute("SELECT DISTINCT main_artist, album FROM metadata_ref WHERE album != ''")
    rows = cursor.fetchall()
    
    print(f"--- Début du traitement de {len(rows)} albums ---")

    for artist, album in rows:
        # Nettoyage des noms (certains ont des quotes en trop dans ta DB)
        artist_clean = artist.strip("'").strip()
        album_clean = album.strip("'").strip()
        
        album_id = get_album_id(artist_clean, album_clean)

        # Vérifier si on l'a déjà pour ne pas gaspiller de requêtes API
        cursor.execute("SELECT id FROM library WHERE id = ?", (album_id,))
        if cursor.fetchone():
            print(f"Saut : {artist_clean} - {album_clean} (Déjà en base)")
            continue

        print(f"Recherche : {artist_clean} - {album_clean}...", end=" ", flush=True)
        
        img_url = fetch_album_art(artist_clean, album_clean)

        if img_url and img_url.strip() != "":
            try:
                cursor.execute("INSERT OR REPLACE INTO library (id, url, type) VALUES (?, ?, ?)", 
                               (album_id, img_url, 2))
                conn.commit()
                print("✅ Ajouté")
            except Exception as e:
                print(f"❌ Erreur SQL: {e}")
        else:
            print("⚠️ Non trouvé")

        # Petite pause pour respecter les limites de l'API Last.fm
        time.sleep(0.2)

    conn.close()
    print("--- Fin du script ---")

if __name__ == "__main__":
    main()
