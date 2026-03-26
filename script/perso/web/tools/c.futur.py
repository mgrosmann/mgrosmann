import sqlite3
from datetime import datetime, timedelta
from collections import defaultdict

# ================= CONFIGURATION FACILE =================
# 1. Date de début pour calculer ton rythme (Croissance)
# Par défaut : les 10 derniers jours
DEBUT_ANALYSE = datetime(2026, 3, 11) 

# 2. Date de fin pour l'estimation (Cible
# Change le mois ici (ex: month=4 pour Avril, month=5 pour Mai)
DATE_CIBLE = datetime(2026, 12, 31, 23, 59) 

# 3. Nom de l'affichage
TITRE_PREVISION = "FIN MARS 2026"
# ========================================================

def get_projection():
    conn = sqlite3.connect("/mnt/c/Partage/web/matheofm.db")
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    now = datetime.now()

    # Calcul des durées
    days_passed = (now - DEBUT_ANALYSE).total_seconds() / 86400
    days_remaining = (DATE_CIBLE - now).total_seconds() / 86400
    
    # Sécurité si la date cible est dépassée
    if days_remaining < 0: days_remaining = 0

    # Récupération des données du mois actuel
    month_start = now.replace(day=1, hour=0, minute=0, second=0).timestamp()
    query = "SELECT m.main_artist, m.album, s.timestamp FROM scrobbles s JOIN metadata_ref m ON s.track_id = m.track_id WHERE s.timestamp >= ?"
    cursor.execute(query, (month_start,))
    rows = cursor.fetchall()

    stats = defaultdict(lambda: {"total_month": 0, "ref_count": 0})
    for r in rows:
        key = (r['main_artist'], r['album'])
        stats[key]["total_month"] += 1
        if r['timestamp'] >= DEBUT_ANALYSE.timestamp():
            stats[key]["ref_count"] += 1

    # Classement actuel
    current_ranking = sorted(stats.items(), key=lambda x: x[1]["total_month"], reverse=True)
    current_pos = {key: i+1 for i, (key, _) in enumerate(current_ranking)}

    # Calcul projection
    predictions = []
    for (artist, album), data in stats.items():
        daily_rate = data["ref_count"] / max(days_passed, 0.1)
        projected_final = round(data["total_month"] + (daily_rate * days_remaining))
        
        icon = "➡️"
        if daily_rate > 15: icon = "🔥"
        elif daily_rate > 5: icon = "⚡"
        elif daily_rate < 1: icon = "🧊"

        predictions.append({
            "key": (artist, album), "artist": artist, "album": album,
            "current_score": data["total_month"], "projected": projected_final, "icon": icon
        })

    predictions = sorted(predictions, key=lambda x: x["projected"], reverse=True)

    print(f"\n🔮 PRÉVISIONS : {TITRE_PREVISION}")
    print(f"📊 Basé sur ton rythme depuis le {DEBUT_ANALYSE.strftime('%d/%m')}")
    print(f"⏳ Temps restant : {round(days_remaining, 1)} jours")
    print("-" * 105)
    print(f"{'Rang':<4} | {'Évol.':<6} | {'Artiste - Album':<40} | {'Actuel':<8} | {'PRÉVU':<8} | {'Style'}")
    print("-" * 105)

    for i, p in enumerate(predictions[:15], 1):
        rank_now = current_pos[p["key"]]
        diff = rank_now - i
        evol = "  ="
        if diff > 0: evol = f"▲ +{diff}"
        elif diff < 0: evol = f"▼ {diff}"

        name = f"{p['artist']} - {p['album']}"
        print(f"#{i:<3} | {evol:<6} | {name[:38]:<40} | {p['current_score']:<8} | {p['projected']:<8} | {p['icon']}")

    conn.close()

if __name__ == "__main__":
    get_projection()
