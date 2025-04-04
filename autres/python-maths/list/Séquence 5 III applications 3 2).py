import random

def liste_alea():
    resultat = []
    
    while i != 10:
        i = random.randint(0, 20)
        resultat.append(i)
    
    return resultat

resultat = liste_alea()
print(resultat)
