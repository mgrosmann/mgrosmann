import json
import csv

def load_mapping(filename):
    """Charge un fichier CSV (séparateur ;) en dictionnaire {variante: fusion}"""
    mapping = {}
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            # On saute la première ligne (header)
            reader = csv.reader(f, delimiter=';')
            next(reader, None) 
            for row in reader:
                if len(row) >= 2:
                    # La version propre est toujours le dernier élément de la ligne
                    clean_version = row[-1].strip()
                    # Toutes les autres colonnes avant sont des variantes à remplacer
                    for variant in row[:-1]:
                        if variant.strip():
                            mapping[variant.strip().lower()] = clean_version
    except FileNotFoundError:
        print(f"⚠️ Fichier {filename} non trouvé, sauté.")
    return mapping

def apply_fusions():
    # 1. Chargement des dictionnaires
    artist_map = load_mapping('artist.txt')
    album_map = load_mapping('album.txt')
    track_map = load_mapping('track.txt')

    # 2. Chargement des scrobbles
    with open('/mnt/c/Partage/web/scrobbles.json', 'r', encoding='utf-8') as f:
        scrobbles = json.load(f)

    cleaned_count = 0

    # 3. Application des fusions
    for s in scrobbles:
        # Nettoyage Artiste
        art_low = s['artist'].lower()
        if art_low in artist_map:
            s['artist'] = artist_map[art_low]
            cleaned_count += 1

        # Nettoyage Album
        alb_low = s['album'].lower()
        if alb_low in album_map:
            s['album'] = album_map[alb_low]
            cleaned_count += 1

        # Nettoyage Track
        tra_low = s['track'].lower()
        if tra_low in track_map:
            s['track'] = track_map[tra_low]
            cleaned_count += 1

    # 4. Sauvegarde
    with open('/mnt/c/Partage/web/scrobbles_cleaned.json', 'w', encoding='utf-8') as f:
        json.dump(scrobbles, f, indent=2, ensure_ascii=False)

    print(f"✅ Terminé ! {cleaned_count} modifications appliquées.")
    print("📁 Fichier créé : scrobbles_cleaned.json")

if __name__ == "__main__":
    apply_fusions()
