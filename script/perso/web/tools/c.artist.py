import sqlite3
from datetime import datetime, timedelta
from collections import defaultdict

def analyze_artist_growth():
    artist_query = input("Entrez le nom de l'Artiste : ").strip()
    
    if not artist_query:
        print("❌ Vous devez saisir un nom d'artiste.")
        return

    conn = sqlite3.connect("/mnt/c/Partage/web/matheofm.db")
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    # Requête pour TOUTES les écoutes de l'artiste (peu importe l'album)
    query = """
        SELECT s.timestamp, m.track, m.album
        FROM scrobbles s
        JOIN metadata_ref m ON s.track_id = m.track_id
        WHERE m.artists LIKE ? OR m.main_artist LIKE ?
        ORDER BY s.timestamp ASC
    """
    cursor.execute(query, (f"%{artist_query}%", f"%{artist_query}%"))
    rows = cursor.fetchall()

    if not rows:
        print(f"❌ Aucun scrobble trouvé pour '{artist_query}'.")
        conn.close()
        return

    # --- LOGIQUE CALENDAIRE ---
    first_dt = datetime.fromtimestamp(rows[0]['timestamp'])
    # Aligner sur le lundi matin
    current_week_start = (first_dt - timedelta(days=first_dt.weekday())).replace(hour=0, minute=0, second=0)
    
    now = datetime.now()
    prev_count = 0
    total_found = 0
    monthly_stats = defaultdict(int)
    album_stats = defaultdict(int)
    track_stats = defaultdict(int)

    print(f"\n📈 ANALYSE DE L'ARTISTE : {artist_query.upper()}")
    print("-" * 85)
    print(f"{'Période':<25} | {'Écoutes':<8} | {'Croissance':<12} | {'Tendance'}")
    print("-" * 85)

    while current_week_start <= now:
        week_end = current_week_start + timedelta(days=7)
        ts_start = current_week_start.timestamp()
        ts_end = week_end.timestamp()

        count = 0
        for r in rows:
            if ts_start <= r['timestamp'] < ts_end:
                count += 1
                # Statistiques globales pour les résumés
                monthly_stats[datetime.fromtimestamp(r['timestamp']).strftime("%m/%Y")] += 1
                album_stats[r['album']] += 1
                track_stats[r['track']] += 1

        total_found += count

        # Calcul croissance
        growth_str = "---"
        if prev_count > 0:
            diff = ((count - prev_count) / prev_count) * 100
            growth_str = f"{'+' if diff >= 0 else ''}{diff:.1f}%"

        # Tendance visuelle (1 carré = 10 écoutes pour les artistes car souvent plus gros volume)
        bar = "█" * (count // 10)

        date_range = f"{current_week_start.strftime('%d/%m')} au { (week_end - timedelta(seconds=1)).strftime('%d/%m/%Y')}"
        status = " (En cours)" if current_week_start <= now < week_end else ""
        
        if count > 0 or (total_found > 0 and current_week_start < datetime.fromtimestamp(rows[-1]['timestamp'])):
            print(f"{date_range:<25} | {count:<8} | {growth_str:<12} | {bar}{status}")

        prev_count = count
        current_week_start = week_end
        
        # Sécurité arrêt
        if total_found > 0 and current_week_start > datetime.fromtimestamp(rows[-1]['timestamp']) + timedelta(days=21):
            break

    # --- TOP 3 ALBUMS ET TOP 3 TITRES ---
    print("-" * 85)
    top_albums = sorted(album_stats.items(), key=lambda x: x[1], reverse=True)[:3]
    top_tracks = sorted(track_stats.items(), key=lambda x: x[1], reverse=True)[:3]

    print(f"💿 TOP ALBUMS : ", end="")
    print(" | ".join([f"{name} ({c})" for name, c in top_albums]))
    
    print(f"🎵 TOP TITRES : ", end="")
    print(" | ".join([f"{name} ({c})" for name, c in top_tracks]))

    # --- RÉSUMÉ MENSUEL ---
    print("\n📅 TOTAL PAR MOIS")
    sorted_months = sorted(monthly_stats.keys(), key=lambda x: datetime.strptime(x, "%m/%Y"))
    for m in sorted_months:
        print(f"  ● {m:<10} : {monthly_stats[m]:>4} écoutes")
    
    print(f"\n✅ TOTAL GÉNÉRAL : {total_found} écoutes")
    conn.close()

if __name__ == "__main__":
    analyze_artist_growth()
