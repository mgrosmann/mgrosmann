import unicodedata
import hashlib
import re

def clean_for_key(text):
    """Nettoyage ultime : minuscule, pas d'accent, pas de spécial, pas d'espace"""
    if not text: return ""
    # 1. Minuscule
    text = str(text).lower().strip()
    # 2. Supprimer les accents (NFD + filtrage)
    text = "".join(c for c in unicodedata.normalize('NFD', text) if unicodedata.category(c) != 'Mn')
    # 3. Supprimer tout ce qui n'est pas lettre ou chiffre (enlever -, ', space, etc.)
    text = re.sub(r'[^a-z0-9]', '', text)
    return text

def get_main_artist(text):
    """Isole le premier artiste avant les feat/&/,/@"""
    if not text: return ""
    # On harmonise les séparateurs
    clean = text.replace(" & ", ";").replace(" , ", ";").replace(",", ";").replace(" x ", ";")
    # On coupe avant le premier (FEAT ou FEAT.
    upper_clean = clean.upper()
    for feat_word in [" (FEAT", " FEAT.", " FT.", " WITH "]:
        if feat_word in upper_clean:
            clean = clean[:upper_clean.find(feat_word)]
    return clean.split(";")[0].strip()

def generate_key(text):
    """Génère le MD5 final"""
    cleaned = clean_for_key(text)
    return hashlib.md5(cleaned.encode('utf-8')).hexdigest()