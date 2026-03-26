import sqlite3
from datetime import datetime, timedelta
from collections import defaultdict

def analyze_growth():
    artist_query = input("Entrez le nom de l'Artiste : ").strip()
    album_query = input("Entrez le nom de l'Album : ").strip()
    
    if not artist_query or not album_query:
        print("❌ Saisie incomplète.")
        return

    conn = sqlite3.connect("/mnt/c/Partage/web/matheofm.db")
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    # Requête pour les scrobbles + récupération des noms de titres pour le Top
    query = """
        SELECT s.timestamp, m.track
        FROM scrobbles s
        JOIN metadata_ref m ON s.track_id = m.track_id
        WHERE m.main_artist LIKE ? AND m.album like ?
        ORDER BY s.timestamp ASC
    """
    cursor.execute(query, (f"%{artist_query}%", f"%{album_query}%"))
    rows = cursor.fetchall()

    if not rows:
        print(f"❌ Aucun résultat.")
        conn.close()
        return

    # --- CALCULS ---
    first_dt = datetime.fromtimestamp(rows[0]['timestamp'])
    current_week_start = (first_dt - timedelta(days=first_dt.weekday())).replace(hour=0, minute=0, second=0)
    
    now = datetime.now()
    prev_count = 0
    total_found = 0
    monthly_stats = defaultdict(int)
    track_counts = defaultdict(int)

    print(f"\n📊 ANALYSE DE PERFORMANCE : {album_query.upper()}")
    print(f"🎤 ARTISTE : {artist_query.upper()}")
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
                track_counts[r['track']] += 1
                month_key = datetime.fromtimestamp(r['timestamp']).strftime("%m/%Y")
                monthly_stats[month_key] += 1

        total_found += count

        # Croissance
        growth_str = "---"
        if prev_count > 0:
            diff = ((count - prev_count) / prev_count) * 100
            growth_str = f"{'+' if diff >= 0 else ''}{diff:.1f}%"

        # Graphique ASCII (1 caractère = 5 écoutes)
        bar = "█" * (count // 5)

        date_range = f"{current_week_start.strftime('%d/%m')} au { (week_end - timedelta(seconds=1)).strftime('%d/%m/%Y')}"
        status = " (En cours)" if current_week_start <= now < week_end else ""
        
        if count > 0 or (total_found > 0 and current_week_start < datetime.fromtimestamp(rows[-1]['timestamp'])):
            print(f"{date_range:<25} | {count:<8} | {growth_str:<12} | {bar}{status}")

        prev_count = count
        current_week_start = week_end
        if total_found > 0 and current_week_start > datetime.fromtimestamp(rows[-1]['timestamp']) + timedelta(days=14):
            break

    # --- TOP TITRE DE L'ALBUM ---
    top_track = max(track_counts, key=track_counts.get)
    
    print("-" * 85)
    print(f"🏆 TITRE LE PLUS ÉCOUTÉ : {top_track} ({track_counts[top_track]} écoutes)")
    
    # --- RÉSUMÉ MENSUEL ---
    print("\n📅 RÉSUMÉ MENSUEL")
    sorted_months = sorted(monthly_stats.keys(), key=lambda x: datetime.strptime(x, "%m/%Y"))
    for m in sorted_months:
        print(f"  ● {m:<10} : {monthly_stats[m]:>4} écoutes")
    
    print(f"\n✅ TOTAL GÉNÉRAL : {total_found} écoutes")
    conn.close()

if __name__ == "__main__":
    analyze_growth()
