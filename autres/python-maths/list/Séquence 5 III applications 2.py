def saisie(n):
    L=[]
    for i in range(n) :
        valeur=str((input("saisir un valeur")))
        L.append(valeur)
    return L

print(saisie(4))
