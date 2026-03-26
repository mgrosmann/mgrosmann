import json
import re
import os

def super_clean(text):
    """Nettoie le texte pour créer une clé de comparaison stable."""
    if not text: return ""
    # On prend le premier artiste avant les séparateurs
    first_part = re.split(r'[,&/]| et | x | feat| ft\.', text, flags=re.IGNORECASE)[0]
    return re.sub(r'[^a-z0-9]', '', first_part.lower()).strip()

def purge():
    base_path = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(base_path, 'scrobbles.json')

    if not os.path.exists(file_path):
        print("❌ Fichier scrobbles.json introuvable.")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            print("❌ Erreur de lecture du JSON.")
            return

    # 1. Trier par timestamp d'abord pour la comparaison chronologique
    data.sort(key=lambda x: x.get('timestamp', 0))

    final_scrobbles = []
    feat_markers = ["&", "feat", "ft.", "with", "et", ","]

    for current in data:
        if not final_scrobbles:
            final_scrobbles.append(current)
            continue

        previous = final_scrobbles[-1]
        
        # --- CRITÈRES DE DOUBLON ---
        # Même artiste principal et même titre
        same_artist = super_clean(current.get('artist', '')) == super_clean(previous.get('artist', ''))
        same_track = super_clean(current.get('track', '')) == super_clean(previous.get('track', ''))
        
        # Écart de temps inférieur à 100 secondes
        time_diff = abs(current.get('timestamp', 0) - previous.get('timestamp', 0))
        
        if same_artist and same_track and time_diff < 100:
            # C'est un doublon ! On choisit lequel garder
            art_curr = current.get('artist', '')
            art_prev = previous.get('artist', '')
            
            curr_has_feat = any(m in art_curr.lower() for m in feat_markers)
            prev_has_feat = any(m in art_prev.lower() for m in feat_markers)

            # Si le nouveau a plus d'infos (feat ou longueur), on remplace le précédent
            if (curr_has_feat and not prev_has_feat) or (len(art_curr) > len(art_prev)):
                final_scrobbles[-1] = current
            # Sinon, on garde le 'previous' déjà inséré et on ignore le 'current'
        else:
            # Ce n'est pas un doublon, on l'ajoute à la liste
            final_scrobbles.append(current)

    # Sauvegarde
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(final_scrobbles, f, indent=2, ensure_ascii=False)

    print(f"✨ Purge terminée : {len(final_scrobbles)} scrobbles conservés.")

if __name__ == "__main__":
    purge()
