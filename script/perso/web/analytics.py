import sqlite3
from datetime import datetime, timedelta
from collections import defaultdict
from query_builder import get_query_by_category

def get_top_stats(cursor, where_str, params):
    """Récupère les données limitées au Top 20 avec détails pour les tooltips"""
    
    # 1. TOP 20 ARTISTES AVEC DÉTAILS ALBUMS (via la nouvelle query détaillée)
    query_artists = f"""
        SELECT name, count, detail 
        FROM ({get_query_by_category('artists_with_detail', where_str)})
        LIMIT 20
    """
    cursor.execute(query_artists, params)
    top_artists = [dict(r) for r in cursor.fetchall()]

    # 2. TOP 20 ALBUMS
    query_albums = f"""
        SELECT name, count 
        FROM ({get_query_by_category('albums', where_str)})
        LIMIT 20
    """
    cursor.execute(query_albums, params)
    top_albums = [dict(r) for r in cursor.fetchall()]

    return {
        "artists": top_artists,
        "albums": top_albums
    }

def get_daily_scrobbles(cursor, where_str, params):
    """Récupère les écoutes jour par jour pour le graphique en courbe"""
    query = get_query_by_category('daily_scrobbles', where_str)
    cursor.execute(query, params)
    return [dict(row) for row in cursor.fetchall()]

def get_projection_data(cursor, where_str, params):
    """Logique de c.futur.py : Prédiction de fin de mois"""
    now = datetime.now()
    if now.month == 12:
        target_date = now.replace(year=now.year+1, month=1, day=1)
    else:
        target_date = now.replace(month=now.month+1, day=1)
    
    days_remaining = (target_date - now).total_seconds() / 86400
    
    # On récupère le top du mois en cours pour projeter
    query = f"""
        SELECT REPLACE(m.main_artist, "'", "") as artist, 
               REPLACE(m.album, "'", "") as name, 
               COUNT(*) as count, l.url as album_img
        FROM scrobbles s 
        JOIN metadata_ref m ON s.track_id = m.track_id
        LEFT JOIN library l ON REPLACE(s.album_id, "'", "") = l.id AND l.type = 2
        {where_str}
        GROUP BY m.main_artist, m.album ORDER BY count DESC LIMIT 10
    """
    cursor.execute(query, params)
    
    rows = []
    # Calcul basé sur le début du mois ou les 10 derniers jours
    days_passed = max((now - datetime.fromtimestamp(params[0] if params else now.timestamp())).days, 1)
    
    for r in cursor.fetchall():
        d = dict(r)
        daily_rate = d['count'] / max(days_passed, 0.1)
        d['projected'] = round(d['count'] + (daily_rate * days_remaining))
        d['icon'] = "🔥" if daily_rate > 15 else "⚡" if daily_rate > 5 else "➡️"
        rows.append(d)
    return rows

def get_growth_stats(cursor, artist=None, album=None):
    """Logique de croissance hebdomadaire (8 dernières semaines)"""
    where_clauses = []
    params = []
    
    if artist:
        where_clauses.append("(m.artists LIKE ? OR m.main_artist LIKE ?)")
        params.extend([f"%{artist}%", f"%{artist}%"])
    if album:
        where_clauses.append("m.album LIKE ?")
        params.append(f"%{album}%")
        
    where_str = " WHERE " + " AND ".join(where_clauses) if where_clauses else ""
    
    query = f"""
        SELECT s.timestamp FROM scrobbles s
        JOIN metadata_ref m ON s.track_id = m.track_id
        {where_str} ORDER BY s.timestamp ASC
    """
    cursor.execute(query, params)
    rows = cursor.fetchall()
    if not rows: return []

    weeks = defaultdict(int)
    for r in rows:
        dt = datetime.fromtimestamp(r['timestamp'])
        start_week = (dt - timedelta(days=dt.weekday())).strftime('%Y-%m-%d')
        weeks[start_week] += 1
        
    growth_data = []
    sorted_weeks = sorted(weeks.items())
    prev_count = 0
    
    for week_date, count in sorted_weeks:
        growth = 0
        if prev_count > 0:
            growth = ((count - prev_count) / prev_count) * 100
        
        growth_data.append({
            "name": week_date,
            "count": count,
            "growth": round(growth, 1),
            "label": f"{'+' if growth >= 0 else ''}{round(growth, 1)}%"
        })
        prev_count = count
        
    return growth_data[-8:]

def get_stats_data(cursor, where_str, params, artist=None, album=None):
    """Fonction pilier qui rassemble TOUTES les données pour le dashboard"""
    
    # 1. Décennies
    query_decades = get_query_by_category("stats_decades", where_str)
    cursor.execute(query_decades, params)
    decades = [dict(row) for row in cursor.fetchall()]

    # 2. Top Artistes (avec détails) et Top Albums
    tops = get_top_stats(cursor, where_str, params)

    # 3. Évolution quotidienne (La courbe)
    daily = get_daily_scrobbles(cursor, where_str, params)

    # 4. Projections et Croissance
    predictions = get_projection_data(cursor, where_str, params)
    growth = get_growth_stats(cursor, artist=artist, album=album)

    return {
        "decades": decades,
        "top_artists": tops['artists'],
        "top_albums": tops['albums'],
        "daily_scrobbles": daily,
        "predictions": predictions,
        "growth": growth
    }
