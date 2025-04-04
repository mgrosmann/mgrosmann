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

def maximum(L):
    M=L[0]
    for i in range (len(L)) :
        if L[i]>M:
            M=L[i]
    return M



def altmax():
    altitude_maximale = 0
    nb_max = 0

    for i in range(1, 1001):
        L = syracuse(i)
        maxi = maximum(L)

        if maxi > altitude_maximale:
            altitude_maximale = maxi
            nb_max = i

    print(f"L'entier max est {nb_max} et son altitude max est égal à  {altitude_maximale}.")

altmax()