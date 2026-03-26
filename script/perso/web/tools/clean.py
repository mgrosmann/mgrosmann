import sqlite3

conn = sqlite3.connect('/mnt/c/Partage/web/matheofm.db')
cursor = conn.cursor()

# Supprime les lignes identiques (même artiste, titre et seconde) en gardant un seul exemplaire
cursor.execute("""
    DELETE FROM scrobbles 
    WHERE rowid NOT IN (
        SELECT MIN(rowid) 
        FROM scrobbles 
        GROUP BY main_artist, track, timestamp
    )
""")

conn.commit()
conn.close()
print("Base de données nettoyée des anciens doublons !")
