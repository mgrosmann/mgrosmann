def commun(liste0, liste1):
    communs = list(set(liste0) & set(liste1))
    return communs
liste_a = [1, 2, 4, 5, 12]
liste_b = [1, 3, 5, 12, 15]
resultat = commun(liste_a, liste_b)
print(f"chiffre communs : {resultat}")


def commun(liste0, liste1):
    liste_c = []
    liste_d = []
    caca = []
    for i in range (len(liste0)):
        if liste0[i] in liste1:
            caca.append(liste0[i])
    return caca
liste_c = [1, 2, 4, 5, 12]
liste_d = [1, 3, 5, 12, 15]
#print(commun(liste_c, liste_d))
            


        






liste_d = [1, 2, 4, 5, 12]
liste_c = [1, 3, 5, 12, 15]