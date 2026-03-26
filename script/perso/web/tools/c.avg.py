import sqlite3
from datetime import datetime, timedelta

def get_weekly_breakdown(month, year):
    conn = sqlite3.connect("/mnt/c/Partage/web/matheofm.db")
    cursor = conn.cursor()

    # 1. Définir la période du mois
    start_date = datetime(year, month, 2)
    if month == 12:
        end_date = datetime(year + 1, 1, 1)
    else:
        end_date = datetime(year, month + 1, 1)

    start_ts = int(start_date.timestamp())
    end_ts = int(end_date.timestamp())

    print(f"--- Statistiques de {start_date.strftime('%B %Y')} ---")
    
    current_week_start = start_date
    week_num = 1
    total_scrobbles_month = 0
    days_in_month = (end_date - start_date).days

    # 2. Boucle par tranches de 7 jours
    while current_week_start < end_date:
        next_week_start = current_week_start + timedelta(days=7)
        
        # On s'assure de ne pas dépasser la fin du mois pour la dernière "semaine"
        actual_end = min(next_week_start, end_date)
        num_days = (actual_end - current_week_start).days
        
        ts1 = int(current_week_start.timestamp())
        ts2 = int(actual_end.timestamp())

        cursor.execute("SELECT COUNT(*) FROM scrobbles WHERE timestamp >= ? AND timestamp < ?", (ts1, ts2))
        count = cursor.fetchone()[0]
        total_scrobbles_month += count

        avg_daily = count / num_days if num_days > 0 else 0
        
        date_range = f"{current_week_start.day:02d} au {(actual_end - timedelta(days=1)).day:02d}"
        print(f"Semaine {week_num} ({date_range}) : {count} sons | Moyenne: {avg_daily:.1f} / jour")

        current_week_start = next_week_start
        week_num += 1

    # 3. Calcul final
    global_avg = total_scrobbles_month / days_in_month
    
    print("-" * 40)
    print(f"TOTAL MOIS : {total_scrobbles_month} écoutes")
    print(f"MOYENNE GÉNÉRALE DU MOIS : {global_avg:.1f} écoutes / jour")

    conn.close()

# Lance le script pour Mars 2026 (ou le mois actuel)
if __name__ == "__main__":
    get_weekly_breakdown(3, 2026)
