import sqlite3, hashlib, unicodedata, re
from query_builder import get_query_by_category
from analytics import get_top_stats, get_projection_data, get_growth_stats, get_daily_scrobbles

def normalize_for_key(text):
    """Normalise le texte pour la correspondance MD5"""
    if not text: return ""
    text = "".join([c for c in unicodedata.normalize('NFKD', str(text)) if not unicodedata.combining(c)])
    return re.sub(r'[^a-z0-9]', '', text.lower())

def md5_hex(text):
    """Génère le hash MD5 pour les images"""
    clean = normalize_for_key(text)
    return hashlib.md5(clean.encode('utf-8')).hexdigest() if clean else ""

def get_stats(category, start=None, end=None, artist=None, album=None, decade=None):
    conn = sqlite3.connect("matheofm.db")
    conn.create_function("py_md5", 1, md5_hex)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    ts_start = int(start) if (start and start != 'null' and start != "") else 0
    ts_end = int(end) if (end and end != 'null' and end != "") else 2147483647
    
    # 1. Base commune : Filtre de temps (période sélectionnée)
    base_clauses = ["s.timestamp BETWEEN ? AND ?"]
    base_params = [ts_start, ts_end]

    # 2. Construction des filtres additionnels (Artiste / Album)
    extra_clauses = []
    extra_params = []

    if artist:
        clean_art = artist.strip("'")
        extra_clauses.append("REPLACE(m.artists, \"'\", \"\") LIKE ?")
        extra_params.append(f"%{clean_art}%")
        
    if album:
        clean_alb = album.strip("'")
        extra_clauses.append("REPLACE(m.album, \"'\", \"\") = ?")
        extra_params.append(clean_alb)

    # Version GLOABLE (Sans décennie) pour le dashboard
    where_str_global = " WHERE " + " AND ".join(base_clauses + extra_clauses)
    params_global = base_params + extra_params

    # Version FILTRÉE (Avec décennie) pour les listes de détails
    if decade and decade != 'null' and category != "stats":
        prefix = decade[:3] # Ex: '201' pour '2010s'
        extra_clauses.append("REPLACE(m.release_year, \"'\", \"\") LIKE ?")
        extra_params.append(f"{prefix}%")

    where_str = " WHERE " + " AND ".join(base_clauses + extra_clauses)
    params = base_params + extra_params

    # CAS A : Requête du Dashboard principal
    if category == "stats":
        # On utilise where_str_global pour que le Top 20 reste fixe
        cursor.execute(get_query_by_category("stats_decades", where_str_global), params_global)
        decades = [dict(row) for row in cursor.fetchall()]

        cursor.execute(get_query_by_category("albums", where_str_global), params_global)
        top_albums = [dict(row) for row in cursor.fetchall()][:20]

        cursor.execute(get_query_by_category("top_artists_with_projects", where_str_global), params_global + params_global)
        top_artists = [dict(row) for row in cursor.fetchall()]

        cursor.execute(get_query_by_category("daily_scrobbles", where_str_global), params_global)
        daily_data = [dict(row) for row in cursor.fetchall()]

        cursor.execute(get_query_by_category("artist_evolution", where_str_global), params_global)
        all_evo = [dict(row) for row in cursor.fetchall()]
        top_15_names = [a['name'] for a in top_artists[:15]]
        evolution = [r for r in all_evo if r['name'] in top_15_names]

        conn.close()
        return {
            "decades": decades,
            "top_artists": top_artists,
            "top_albums": top_albums,
            "daily_scrobbles": daily_data,
            "artist_evolution": evolution
        }

    # CAS B : Requêtes de listes (ex: /api/albums?decade=2010s)
    query = get_query_by_category(category, where_str)
    cursor.execute(query, params)
    rows = [dict(r) for r in cursor.fetchall()]
    conn.close()
    return rows
