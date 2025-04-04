def syracuse(n):
    L = [n]
    valeur = n
    while valeur != 1:
        if valeur % 2 == 0:
            valeur = valeur // 2
        else:
            valeur = valeur * 3 + 1
        L.append(valeur)
    return L

def vol(volfixe):
    nb = 1
    L = syracuse(nb)
    while len(L) - 1 != volfixe:
        nb = nb + 1
        L = syracuse(nb)
    return nb

duree_vol_fixe = 15
resultat = vol(duree_vol_fixe)
print("La plus petite valeur de départ avec une durée de vol de", duree_vol_fixe, "est :", resultat)
