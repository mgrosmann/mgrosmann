import sqlite3
import musicbrainzngs
import os
import time

# Configuration API MusicBrainz
musicbrainzngs.set_useragent("MyMusicApp", "0.1", "contact@example.com")

def get_album_year(album_name, artist_name):
    """Interroge MusicBrainz pour trouver l'année de sortie."""
    try:
        result = musicbrainzngs.search_release_groups(query=album_name, artist=artist_name)
        if result["release-group-list"]:
            best = result["release-group-list"][0]
            if "first-release-date" in best:
                return best["first-release-date"][:4]
    except Exception as e:
        print(f"Erreur MusicBrainz pour {album_name}: {e}")
    return "Inconnu"


def main():
    db_path = "/mnt/c/Partage/web/matheofm.db"
    output_dir = "/mnt/c/Partage/web/annees_sorties"

    os.makedirs(output_dir, exist_ok=True)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # 🔥 On ne prend que les albums sans année, et valides
    cursor.execute("""
        SELECT DISTINCT album, main_artist 
        FROM metadata_ref 
        WHERE (release_year = 0 OR release_year IS NULL)
          AND album IS NOT NULL AND album <> ''
          AND main_artist IS NOT NULL AND main_artist != ''
    """)
    rows = cursor.fetchall()

    print(f"🔍 {len(rows)} albums sans année à traiter...")

    for album, artist in rows:
        album_clean = album.strip("'")
        artist_clean = artist.strip("'")

        print(f"\n➡️ Album : {album_clean} — {artist_clean}")

        # Recherche MusicBrainz
        print("   🔎 Recherche MusicBrainz…")
        year = get_album_year(album_clean, artist_clean)

        # Mise à jour DB
        cursor.execute("""
            UPDATE metadata_ref 
            SET release_year = ? 
            WHERE album = ? AND main_artist = ?
        """, (year, album, artist))
        conn.commit()

        print(f"   ✔ Année trouvée : {year}")

        # Écriture dans fichier année
        filename = f"{year}.txt"
        with open(os.path.join(output_dir, filename), "a", encoding="utf-8") as f:
            f.write(f"{artist_clean} - {album_clean}\n")

        print(f"   📁 Ajouté dans {filename}")

        time.sleep(1.1)  # Respect API

    conn.close()
    print("\n✅ Terminé !")


if __name__ == "__main__":
    main()
