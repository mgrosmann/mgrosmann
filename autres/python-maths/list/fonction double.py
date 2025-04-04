def double(liste):
    liste[0] *= 2
    liste[1] *= 2
    liste[2] *= 2
    return liste

def triple(liste):
    liste[0] *= 3
    liste[1] *= 3
    liste[2] *= 3
    return liste

liste = [1, 2, 3]
print(double(liste.copy()))
print(triple(liste.copy()))
print(liste)
