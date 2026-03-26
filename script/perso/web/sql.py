import sqlite3
import json
import os
import re
import unicodedata
from key import generate_key, get_main_artist

# --- 1. LOGIQUE DE FUSION ET CHARGEMENT ---

def load_fusions():
    fusions = {}
    files = ['artist.txt', 'album.txt', 'track.txt']
    for file_name in files:
        if os.path.exists(file_name):
            with open(file_name, 'r', encoding='utf-8') as f:
                for line in f:
                    if ';' not in line or line.startswith('#'): continue
                    parts = [p.strip() for p in line.split(';')]
                    if len(parts) >= 2:
                        final_version = parts[-1]
                        for variant in parts[:-1]:
                            if variant:
                                fusions[variant.lower()] = final_version
    return fusions

FUSION_MAP = load_fusions()

def load_release_years():
    years_map = {}
    folder = 'annees_sorties'
    if not os.path.exists(folder):
        return years_map

    for filename in os.listdir(folder):
        # 🔥 On ignore explicitement Inconnu.txt
        if not filename.endswith(".txt") or filename == "Inconnu.txt":
            continue

        year_str = filename.replace(".txt", "")
        try:
            year = int(year_str)
        except ValueError:
            continue

        with open(os.path.join(folder, filename), 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()

                # 🔥 Ignore les lignes vides ou sans " - "
                if not line or " - " not in line:
                    continue

                parts = line.split(" - ", 1)

                # 🔥 Sécurité supplémentaire
                if len(parts) != 2:
                    continue

                artist = parts[0].strip().lower()
                album = parts[1].strip().lower()

                # 🔥 Ignore les entrées incomplètes
                if not artist or not album:
                    continue

                years_map[(artist, album)] = year

    return years_map


YEARS_MAP = load_release_years()

# --- 2. UTILITAIRES DE NETTOYAGE ---

def apply_fusion(text):
    if not text: return text
    res = FUSION_MAP.get(text.lower().strip(), text.strip())
    return res.title()

def normalize_for_key(text):
    if not text: return ""
    text = unicodedata.normalize('NFKD', str(text))
    text = "".join([c for c in text if not unicodedata.combining(c)])
    text = re.sub(r'[^a-z0-9]', '', text.lower())
    return text

def format_quoted(text):
    if not text: return "''"
    clean_text = str(text).replace("'", "").replace('"', '')
    return f"'{clean_text}'"

def clean_text_from_feats(text):
    if not text: return ""
    # Transforme (feat. en séparateur ;
    text = re.sub(r'\(\s*(?:feat\.?|ft\.?|avec)\s*', ';', text, flags=re.IGNORECASE)
    text = re.sub(r'\s+(?:feat\.?|ft\.?|avec)\s+', ';', text, flags=re.IGNORECASE)
    text = re.sub(r'\s+et\s+', ';', text, flags=re.IGNORECASE)
    text = re.sub(r'\s+x\s+', ';', text, flags=re.IGNORECASE)
    text = text.replace(" & ", ";").replace(", ", ";").replace("·", ";")
    
    parts = []
    for p in text.split(";"):
        clean_p = p.strip()
        # Ne retire ) que si elle est orpheline
        if '(' not in clean_p:
            clean_p = clean_p.replace(')', '')
        # Nettoyage bordures
        clean_p = re.sub(r'^[ (.]+|^[ .]+|[. ]+$', '', clean_p)
        if clean_p:
            parts.append(clean_p)
    return ";".join(parts)

# --- 3. PROCESSUS PRINCIPAL ---

def run_super_process():
    conn = sqlite3.connect('matheofm.db')
    cursor = conn.cursor()
    
    for table in ['scrobbles', 'metadata_ref', 'library']:
        cursor.execute(f'DROP TABLE IF EXISTS {table}')
    
    cursor.execute('CREATE TABLE scrobbles (main_artist TEXT, artists TEXT, album TEXT, track TEXT, timestamp INTEGER, track_id TEXT, album_id TEXT, artist_id TEXT)')
    cursor.execute('CREATE TABLE metadata_ref (track_id TEXT PRIMARY KEY, main_artist TEXT, artists TEXT, album TEXT, track TEXT, release_year INTEGER)')
    cursor.execute('CREATE TABLE library (id TEXT PRIMARY KEY, url TEXT, type INTEGER)')

    if os.path.exists('scrobbles.json'):
        with open('scrobbles.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
            scrobbles_rows, metadata_dict = [], {}

            for i in data:
                raw_t, raw_a, raw_r = i.get('track', ''), i.get('album', ''), i.get('artist', '')
                ts = i.get('timestamp')

                album_clean = apply_fusion(raw_a)
                
                # Isolation titre vs artistes invités dans le titre
                track_name_clean = apply_fusion(raw_t)
                track_artists_part = ""
                if re.search(r'\(?\b(?:feat\.?|ft\.?|avec)\b', raw_t, re.IGNORECASE):
                    parts = re.split(r'\(?\b(?:feat\.?|ft\.?|avec)\b', raw_t, maxsplit=1, flags=re.IGNORECASE)
                    track_name_clean = apply_fusion(parts[0].strip())
                    track_artists_part = parts[1]

                # Main artist
                main_art_clean = apply_fusion(clean_text_from_feats(raw_r).split(';')[0])

                # Liste complète des artistes
                all_arts = clean_text_from_feats(f"{raw_r};{track_artists_part}").split(';')
                unique_arts = []
                for art in all_arts:
                    f_art = apply_fusion(art)
                    # Exclusion des parenthèses de type (Remix) des artistes
                    if f_art and f_art not in unique_arts:
                        if "(" not in f_art and f_art.lower() not in [track_name_clean.lower(), album_clean.lower()]:
                            unique_arts.append(f_art)
                
                final_artists_str = ";".join(unique_arts)

                # Clés unique
                tid = generate_key(f"{normalize_for_key(main_art_clean)}{normalize_for_key(album_clean)}{normalize_for_key(track_name_clean)}")
                alid = generate_key(f"{normalize_for_key(main_art_clean)}{normalize_for_key(album_clean)}")
                arid = generate_key(normalize_for_key(main_art_clean))

                scrobbles_rows.append((format_quoted(main_art_clean), format_quoted(final_artists_str), format_quoted(album_clean), format_quoted(track_name_clean), ts, tid, alid, arid))

                if tid not in metadata_dict or len(final_artists_str) > len(metadata_dict[tid][1]):
                    metadata_dict[tid] = (main_art_clean, final_artists_str, album_clean, track_name_clean)

            cursor.executemany("INSERT INTO scrobbles VALUES (?, ?, ?, ?, ?, ?, ?, ?)", scrobbles_rows)
            for tid, v in metadata_dict.items():
                m_art, a_str, alb, tra = v
                ry = YEARS_MAP.get((m_art.lower(), alb.lower()), 0)
                cursor.execute("INSERT INTO metadata_ref VALUES (?, ?, ?, ?, ?, ?)", (tid, format_quoted(m_art), format_quoted(a_str), format_quoted(alb), format_quoted(tra), ry))

    # --- IMAGES ---
    if os.path.exists('cache_images.json'):
        with open('cache_images.json', 'r', encoding='utf-8') as f:
            img_cache = json.load(f)
            for raw_key, url in img_cache.items():
                if not url or url == "''": continue
                if raw_key.startswith("ARTIST:"):
                    f_name = apply_fusion(clean_text_from_feats(raw_key.replace("ARTIST:", "")).split(';')[0])
                    cursor.execute("INSERT OR REPLACE INTO library VALUES (?, ?, ?)", (generate_key(normalize_for_key(f_name)), format_quoted(url), 1))
                elif raw_key.startswith("ALBUM:"):
                    parts = raw_key.replace("ALBUM:", "").split(" - ", 1)
                    f_art = apply_fusion(clean_text_from_feats(parts[0]).split(';')[0])
                    f_alb = apply_fusion(parts[1]) if len(parts)>1 else ""
                    cursor.execute("INSERT OR REPLACE INTO library VALUES (?, ?, ?)", (generate_key(f"{normalize_for_key(f_art)}{normalize_for_key(f_alb)}"), format_quoted(url), 2))

    conn.commit()
    conn.close()
    print("✅ Base reconstruite proprement.")

if __name__ == "__main__":
    run_super_process()
