from flask import Flask, jsonify, request, render_template
import hashlib
import unicodedata
import re
import sqlite3
import os
import threading
import time
import requests 
from week_core import get_stats
from update_db import update_database 

# Configuration Flask : on définit explicitement les dossiers
app = Flask(__name__, template_folder='templates', static_folder='static')

# --- LOGIQUE DE MISE À JOUR AUTOMATIQUE ---
def scheduler():
    time.sleep(10)
    while True:
        try:
            print("🔄 Mise à jour de la base de données en cours...")
            update_database()
        except Exception as e:
            print(f"❌ Erreur Update DB : {e}")
        time.sleep(600)

threading.Thread(target=scheduler, daemon=True).start()

# --- FONCTION DE GÉNÉRATION D'ID ---
def generate_id_from_metadata(artist, album):
    if not artist or not album: return ""
    # On prend le premier artiste avant le "feat"
    artist_clean = re.split(r' feat\.? | ft\.? | avec | & | \+ | x ', str(artist), flags=re.IGNORECASE)[0]
    raw_text = f"{artist_clean}{album}"
    clean_text = "".join(c for c in unicodedata.normalize('NFKD', raw_text) if not unicodedata.combining(c))
    clean_text = clean_text.lower().replace(" ", "")
    clean_text = re.sub(r'[^a-z0-9]', '', clean_text)
    return hashlib.md5(clean_text.encode('utf-8')).hexdigest()

# --- ROUTES ---

@app.route("/")
def index():
    """Charge la page principale via le moteur de template Jinja2"""
    return render_template('index.html')

@app.route("/api/<category>")
def api(category):
    """Route API générique pour les stats et les listes"""
    page = int(request.args.get("page", 1))
    start = request.args.get("start")
    end = request.args.get("end")
    artist = request.args.get("artist")
    album = request.args.get("album")
    decade = request.args.get('decade')
    data = get_stats(category, start, end, artist, album, decade)

    if category == "stats":
        return jsonify(data)

    # Gestion de la pagination pour les listes (artistes, albums, tracks)
    limit = 50
    if not isinstance(data, list):
        return jsonify({"items": [], "total_count": 0})

    total_count = len(data)
    start_idx = (page - 1) * limit
    end_idx = start_idx + limit
    
    return jsonify({
        "items": data[start_idx : end_idx],
        "total_count": total_count,
        "total_pages": (total_count + limit - 1) // limit,
        "current_page": page
    })

@app.route('/api/now_playing')
def get_now_playing():
    """Vérifie l'écoute en direct sur Last.fm"""
    API_KEY = "26efc00d7f356323fd26b088e0d21a3b"
    USER = "Userx836"
    url = f"http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user={USER}&api_key={API_KEY}&format=json&limit=1"
    
    try:
        resp = requests.get(url, timeout=5)
        data = resp.json()
        tracks = data.get("recenttracks", {}).get("track", [])
        
        if isinstance(tracks, dict): 
            tracks = [tracks]

        if not tracks:
            return jsonify({"active": False})

        track = tracks[0]
        # Vérification critique de l'attribut 'nowplaying'
        is_playing = track.get("@attr", {}).get("nowplaying") == "true"
        
        if is_playing:
            artist_name = track["artist"]["#text"]
            album_name = track["album"]["#text"]
            track_name = track["name"]

            # 1. Fallback image : on prend celle de Last.fm par défaut
            image_url = ""
            lfm_imgs = track.get("image", [])
            if lfm_imgs:
                image_url = lfm_imgs[-1]["#text"] # La plus grande résolution

            # 2. Tentative d'ID pour la base de données locale
            db_id = generate_id_from_metadata(artist_name, album_name)
            
            try:
                conn = sqlite3.connect("matheofm.db")
                cursor = conn.cursor()
                cursor.execute("SELECT url FROM library WHERE id = ?", (db_id,))
                result = cursor.fetchone()
                if result:
                    image_url = result[0].strip("'")
                conn.close()
            except Exception as e:
                print(f"⚠️ Erreur SQL Now Playing: {e}")

            print(f"🎵 En cours : {track_name} - {artist_name}")
            return jsonify({
                "active": True,
                "artist": artist_name,
                "track": track_name,
                "album": album_name,
                "image": image_url
            })
                
    except Exception as e:
        print(f"❌ Erreur API LastFM: {e}")
        
    return jsonify({"active": False})

# --- LANCEMENT DU SERVEUR ---
if __name__ == "__main__":
    # Importante : app.run doit être à la racine du script (hors de toute fonction)
    print("🚀 Serveur MatheoFM démarré sur http://localhost:5000")
    app.run(host='0.0.0.0', port=5000, debug=False)
