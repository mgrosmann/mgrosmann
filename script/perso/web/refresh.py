import requests
import json
import time
import os

API_KEY = "26efc00d7f356323fd26b088e0d21a3b"
USER = "Userx836"
FILENAME = "scrobbles.json"

def refresh_scrobbles():
    # 1. Charger l'existant
    if os.path.exists(FILENAME):
        with open(FILENAME, "r", encoding="utf-8") as f:
            all_scrobbles = json.load(f)
    else:
        print("Fichier scrobbles.json non trouvé. Lancez fetch_scrobbles.py d'abord.")
        return

    # 2. Trouver le timestamp le plus récent
    # On ajoute +1 pour ne pas retélécharger le tout dernier morceau déjà présent
    last_ts = max(t["timestamp"] for t in all_scrobbles) if all_scrobbles else 0
    print(f"Dernière mise à jour trouvée : {time.ctime(last_ts)}")

    new_tracks_count = 0
    page = 1

    while True:
        url = (
            "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks"
            f"&user={USER}&api_key={API_KEY}&format=json&limit=200&page={page}"
            f"&from={last_ts + 1}" 
        )

        try:
            resp = requests.get(url, timeout=10)
            data = resp.json()
        except Exception as e:
            print(f"Erreur : {e}. Nouvel essai dans 2min...")
            time.sleep(120)
            continue

        tracks = data.get("recenttracks", {}).get("track", [])
        
        # Si c'est un dictionnaire seul (un seul scrobble), on le met en liste
        if isinstance(tracks, dict):
            tracks = [tracks]

        if not tracks:
            break

        valid_tracks = []
        for t in tracks:
            if "date" not in t: # Ignore le "Now Playing"
                continue
            valid_tracks.append({
                "artist": t["artist"]["#text"],
                "album": t["album"]["#text"],
                "track": t["name"],
                "timestamp": int(t["date"]["uts"])
            })

        if not valid_tracks:
            break

        all_scrobbles.extend(valid_tracks)
        new_tracks_count += len(valid_tracks)
        print(f"Page {page} : {len(valid_tracks)} nouveaux morceaux récupérés.")

        # Pagination
        meta = data.get("recenttracks", {}).get("@attr", {})
        if page >= int(meta.get("totalPages", 1)):
            break
            
        page += 1
        time.sleep(0.2)

    if new_tracks_count > 0:
        # Trier par date (du plus ancien au plus récent)
        all_scrobbles.sort(key=lambda x: x["timestamp"])
        
        with open(FILENAME, "w", encoding="utf-8") as f:
            json.dump(all_scrobbles, f, indent=2, ensure_ascii=False)
        print(f"Terminé ! {new_tracks_count} nouveaux scrobbles ajoutés.")
    else:
        print("Déjà à jour. Rien à ajouter.")

if __name__ == "__main__":
    refresh_scrobbles()
