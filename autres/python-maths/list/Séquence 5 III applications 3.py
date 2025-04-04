import random

def liste_alea(n):
    return [random.randint(0, 100) for _ in range(n)]

n=29
resultat = liste_alea(n)
print(resultat)

