def occurence(ch,lettre):
    compteur=0
    for i in range(len(ch)):
        if ch[i]==lettre:
            compteur=compteur+1
    return compteur
lettre="s"
chaine="vive les maths"
#print (occurence(chaine, lettre))








chaine="quoicoubeh"
alphabet="abcdefghijklmnopqrstuvwxyz"
tableau=[]
for i in range(26):
    compteur=occurence(chaine, alphabet[i])
    tableau.append(compteur)
print(tableau)

maxi=tableau[0]
indice=0
for i in range(len(tableau)):
    if tableau[i]>maxi:
        maxi=tableau[i]
        indice=i
print("letttre:", alphabet[indice])