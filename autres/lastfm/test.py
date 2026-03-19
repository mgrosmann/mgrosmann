import requests
import time
import re
import unicodedata

API_KEY = "26efc00d7f356323fd26b088e0d21a3b"
USER = "Userx836"

# Détection des feats dans un titre
FEAT_REGEX = re.compile(r"(?i)(feat|ft|featuring)")

def normalize_title(title):
    """Normalise un titre pour fusionner les variantes."""
    
    # 1. enlever les accents
    title = ''.join(
        c for c in unicodedata.normalize('NFD', title)
        if unicodedata.category(c) != 'Mn'
    )

    # 2. tout en minuscules
    title = title.lower()

    # 3. remplacer toutes les variantes de "feat"
    title = re.sub(r'\b(feat|ft|featuring)\b\.?', 'feat', title)

    # 4. supprimer les espaces multiples
    title = re.sub(r'\s+', ' ', title)

    # 5. supprimer les espaces avant parenthèses
    title = re.sub(r'\s+\(', ' (', title)

    # 6. trim final
    return title.strip()


def get_all_scrobbles(user, api_key, limit=200):
    """Télécharge tous les scrobbles de l'utilisateur via l’API Last.fm."""
    page = 1
    all_tracks = []

    while True:
        url = (
            "https://ws.audioscrobbler.com/2.0/"
            f"?method=user.getrecenttracks&user={user}"
            f"&api_key={api_key}&format=json&limit={limit}&page={page}"
        )

        data = requests.get(url).json()

        if "recenttracks" not in data or "track" not in data["recenttracks"]:
            break

        tracks = data["recenttracks"]["track"]
        if not tracks:
            break

        all_tracks.extend(tracks)

        attr = data["recenttracks"]["@attr"]
        if page >= int(attr["totalPages"]):
            break

        page += 1
        time.sleep(0.2)

    return all_tracks


def analyze_artist(artist_name):
    print(f"\nAnalyse API pour : {artist_name}\n")

    tracks = get_all_scrobbles(USER, API_KEY)

    total_artist = 0
    total_feats = 0
    feats_details = {}

    for t in tracks:
        artist = t["artist"]["#text"]
        title = t["name"]

        # Cas 1 : artiste principal
        if artist.lower() == artist_name.lower():
            total_artist += 1

        # Cas unique : artiste invité (feat dans le titre)
        if FEAT_REGEX.search(title) and artist_name.lower() in title.lower():
            normalized = normalize_title(title)
            total_feats += 1
            feats_details[normalized] = feats_details.get(normalized, 0) + 1

    # Affichage
    print(f"Scrobbles artiste principal ({artist_name}) : {total_artist}")
    print(f"Scrobbles en feats : {total_feats}")
    print(f"TOTAL GLOBAL : {total_artist + total_feats}\n")

    print("Classement des feats :")
    for title, count in sorted(feats_details.items(), key=lambda x: x[1], reverse=True):
        print(f"  {title} : {count}")


# Lancer l'analyse
analyze_artist("Booba")

