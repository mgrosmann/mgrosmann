def pgcd(a, b):
    while b:
        a, b = b, a % b
    return a

# Demandez à l'utilisateur d'entrer les deux nombres
a = int(input("Entrez le premier nombre : "))
b = int(input("Entrez le deuxième nombre : "))

# Appelez la fonction pgcd et affichez le résultat
resultat = pgcd(a, b)
print("Le PGCD de", a, "et", b, "est", resultat)
