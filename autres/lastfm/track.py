import requests
import time
import re
import unicodedata
import sys
from datetime import datetime

API_KEY = "26efc00d7f356323fd26b088e0d21a3b"
USER = "Userx836"

FROM = "02-03-2026_00:00:00"
TO   = "19-03-2026_23:59:59"

def convert_date(value):
    if isinstance(value, int):
        return value
    dt = datetime.strptime(value, "%d-%m-%Y_%H:%M:%S")
    return int(dt.timestamp())

FROM = convert_date(FROM)
TO   = convert_date(TO)

# ---------------------------------------------------------
# NORMALISATION
# ---------------------------------------------------------

def normalize_text(text):
    text = ''.join(c for c in unicodedata.normalize('NFD', text)
                   if unicodedata.category(c) != 'Mn')
    text = text.lower()
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

# ---------------------------------------------------------
# PROTECTION ARTISTES (LETO, etc.)
# ---------------------------------------------------------

PROTECTED_ARTISTS = ["leto", "ketama", "meto", "pete", "get", "set"]

def is_protected(name):
    n = normalize_text(name)
    return any(n == p for p in PROTECTED_ARTISTS)

# ---------------------------------------------------------
# FUSION VIA TXT
# ---------------------------------------------------------

def load_fusion_file(path):
    fusion = {}
    try:
        with open(path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                parts = [p.strip() for p in line.split(";")]
                if len(parts) < 2:
                    continue
                variants = parts[:-1]
                final = parts[-1]
                for v in variants:
                    fusion[normalize_text(v)] = final
    except FileNotFoundError:
        pass
    return fusion

TRACK_FUSION = load_fusion_file("track.txt")
ARTIST_FUSION = load_fusion_file("artist.txt")

def fuse_artist(name):
    key = normalize_text(name)
    return ARTIST_FUSION.get(key, name)

def normalize_track(title):
    cleaned = auto_clean_title(title)
    key = normalize_text(cleaned)
    return TRACK_FUSION.get(key, cleaned)

# ---------------------------------------------------------
# AUTO-CLEAN TITRES
# ---------------------------------------------------------

def auto_clean_title(title):
    t = title.strip()
    t = re.sub(r'\s+', ' ', t)
    t = re.sub(r'\(\s+', '(', t)
    t = re.sub(r'\s+\)', ')', t)

    t = re.sub(r'(?i)\b(feat|ft|featuring)\b\.?', 'feat.', t)

    m = re.search(r'\((feat\..*?)\)', t, flags=re.I)
    if not m:
        return t

    inside = m.group(1).lower().replace("feat.", "").strip()

    for sep in ["&", "/", ";", " x ", " X ", ","]:
        inside = inside.replace(sep, ",")

    inside = inside.replace(" ,", ",").replace(", ", ",")
    feats = [p.strip() for p in inside.split(",") if p.strip()]
    feats = sorted(feats, key=lambda x: x.lower())

    base = re.sub(r'\(feat\..*?\)', '', t).strip()
    return f"{base} (feat. {', '.join(feats)})"

# ---------------------------------------------------------
# EXTRACTION INVITÉS
# ---------------------------------------------------------

SEPARATORS = [
    " feat. ", " feat ", " ft. ", " ft ", " featuring ",
    " avec ", " & ", " x ", " X ", " / ", ",", ";"
]

def extract_guests_from_title(title):
    t = title.lower()
    m = re.search(r'\((.*?)\)', t)
    if not m:
        return []

    inside = m.group(1)
    if not re.search(r'(feat|ft|featuring|avec)', inside):
        return []

    inside = inside.replace("feat.", "feat")
    inside = inside.replace("ft.", "feat")
    inside = inside.replace("featuring", "feat")
    inside = inside.replace("avec", "feat")
    inside = re.sub(r'feat', '', inside).strip()

    for sep in ["&", "/", ";", " x ", " X ", ","]:
        inside = inside.replace(sep, ",")

    inside = inside.replace(" ,", ",").replace(", ", ",")
    return [g.strip() for g in inside.split(",") if g.strip()]

def extract_from_artist_field(artist_raw):
    if is_protected(artist_raw):
        return normalize_text(artist_raw), []

    a = " " + artist_raw.lower() + " "

    a = re.sub(r"\bet\b", ",", a)

    for sep in SEPARATORS:
        a = a.replace(sep.strip(), ",")

    parts = [p.strip() for p in a.split(",") if p.strip()]

    if len(parts) == 0:
        return normalize_text(artist_raw), []

    principal = normalize_text(parts[0])
    guests = [normalize_text(g) for g in parts[1:]]
    return principal, guests

# ---------------------------------------------------------
# FUSION FEAT / COLLAB
# ---------------------------------------------------------

def merge_feat_collab(title, principal, guests, all_titles):
    base = normalize_text(re.sub(r'\(feat.*?\)', '', title))

    for t in all_titles:
        if "(feat" in t.lower():
            base_feat = normalize_text(re.sub(r'\(feat.*?\)', '', t))
            if base == base_feat:
                return t

    return title

# ---------------------------------------------------------
# SCROBBLES
# ---------------------------------------------------------

def get_all_scrobbles(user, api_key, limit=200):
    page = 1
    all_tracks = []
    while True:
        url = (
            "https://ws.audioscrobbler.com/2.0/"
            f"?method=user.getrecenttracks&user={user}"
            f"&api_key={api_key}&format=json&limit={limit}&page={page}"
        )
        resp = requests.get(url)
        data = resp.json()

        if "recenttracks" not in data or "track" not in data["recenttracks"]:
            break

        for t in data["recenttracks"]["track"]:
            if "date" not in t:
                continue
            ts = int(t["date"]["uts"])
            if FROM <= ts <= TO:
                all_tracks.append(t)

        attr = data["recenttracks"]["@attr"]
        if page >= int(attr["totalPages"]):
            break
        page += 1
        time.sleep(0.2)

    return all_tracks

# ---------------------------------------------------------
# ANALYSE ARTISTE
# ---------------------------------------------------------

def analyze_artist(artist_name):
    artist_name = normalize_text(fuse_artist(artist_name))

    tracks = get_all_scrobbles(USER, API_KEY)

    total_artist = 0
    total_feats = 0

    main_tracks = {}
    feat_tracks = {}

    for t in tracks:
        artist_raw = fuse_artist(t["artist"]["#text"])
        title_raw = t["name"]

        normalized_title = normalize_track(title_raw)

        title_guests = extract_guests_from_title(title_raw)

        if title_guests:
            principal = normalize_text(artist_raw)
            guests = [normalize_text(fuse_artist(g)) for g in title_guests]
        else:
            principal, guests = extract_from_artist_field(artist_raw)
            principal = fuse_artist(principal)
            guests = [fuse_artist(g) for g in guests]

        normalized_title = merge_feat_collab(
            normalized_title, principal, guests,
            set(main_tracks.keys()) | set(feat_tracks.keys())
        )

        if artist_name == normalize_text(principal):
            total_artist += 1
            main_tracks[normalized_title] = main_tracks.get(normalized_title, 0) + 1

        if artist_name in [normalize_text(g) for g in guests]:
            total_feats += 1
            feat_tracks[normalized_title] = feat_tracks.get(normalized_title, 0) + 1

    print(f"\nScrobbles artiste principal : {total_artist}")
    print(f"Scrobbles en feats : {total_feats}")
    print(f"TOTAL GLOBAL : {total_artist + total_feats}\n")

    print("=== Titres en artiste principal ===")
    for title, count in sorted(main_tracks.items(), key=lambda x: x[1], reverse=True):
        print(f"  {title} : {count}")

    print("\n=== Titres en feat ===")
    for title, count in sorted(feat_tracks.items(), key=lambda x: x[1], reverse=True):
        print(f"  {title} : {count}")

# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 track.py <nom_artiste>")
        sys.exit(1)

    artist = " ".join(sys.argv[1:])
    analyze_artist(artist)

