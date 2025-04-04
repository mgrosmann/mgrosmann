import random
def liste_alea(n):
    i = -1
    resultat = []
    while len(resultat) < n:
        i = random.randint(1, 10)
        resultat.append(i)
    return resultat
resultat = liste_alea(20)
print(resultat)

def singletons(L):
    list0 = []
    for element in L:
        if element not in list0:
            list0.append(element)
    return list0
resultat_single = singletons(resultat)
#print(resultat)
#print (resultat_single)

def nb_occurence(resultat, value):
    count = resultat.count(value)
   # print (resultat)
   # print(f'Count of {value}: {count}')
#nb_occurence(resultat, 1)
    
from collections import Counter
def nb_sup(n):
    i = -1
    resultat = []
    while len(resultat) < n:
        i = random.randint(1, 10)
        resultat.append(i)
    occurrences = Counter(resultat)
    max_occurrences = max(occurrences.values())
    valeur_frequente = [number for number, occurrence in occurrences.items() if occurrence == max_occurrences]
    max_nb_sup = max(valeur_frequente)
    return resultat, max_nb_sup
resultat, max_nb_sup = nb_sup(20)
#print(resultat)
#print("Nombre le plus fréquent:", max_nb_sup)