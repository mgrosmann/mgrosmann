def change_voyelles(ch):
    voyelles="aeiouy"
    nouvelle_chaine=""
    for i in ch:
        if i in voyelles:
            nouvelle_chaine=nouvelle_chaine+"?"
        else:
            nouvelle_chaine=nouvelle_chaine+i
    return nouvelle_chaine

def reverse_string(my_string):
    reversed_string = "".join(reversed(my_string))
    return reversed_string

def reverse_number(my_string):
    reversed_string = "".join(reversed(str(my_string)))
    return reversed_string

def occurence(ch, lettre):
    compteur=0
    for i in range(len(ch)):
        if ch[i]==lettre:
            compteur=compteur+1
    return compteur

def tableau_alphabet(ch):
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    tableau = []
    for lettre in alphabet:
        compteur = occurence(ch, lettre)
        tableau.append((lettre, compteur))
    return tableau

def nb_plus_frequent(ch):
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    tableau = []
    for lettre in alphabet:
        compteur = occurence(ch, lettre)
        tableau.append((lettre, compteur))
    lettre_max, occurence_max = max(tableau, key=lambda x: x[1])
    return lettre_max, occurence_max

def main():
    test = "résultat du programme : bravo vous avez reussi"
    resultat_voyelles = change_voyelles(test)
    print("Résultat du remplacement des voyelles :", resultat_voyelles)
    
    my_string = "bonjour"
    reversed_string = reverse_string(my_string)
    print("Chaîne inversée :", reversed_string)
    
    my_string0 = 12345
    reversed_string = reverse_number(my_string0)
    print("Nombre inversé :", reversed_string)
    
    chaine = "vive les maths"
    lettre = 's'
    nb_occurrences = occurence(chaine, lettre)
    print(f"Nombre d'occurrences de '{lettre}' dans '{chaine}':", nb_occurrences)
    
    chaine2 = "jskfdjlfsdjklfdljk"
    tableau_occurrences = tableau_alphabet(chaine2)
    print("Tableau des occurrences de chaque lettre :", tableau_occurrences)
    
    lettre_plus_frequente, occurence_max = nb_plus_frequent(chaine2)
    print(f"La lettre la plus fréquente dans '{chaine2}' est '{lettre_plus_frequente}' avec {occurence_max} occurrences.")

if __name__ == "__main__":
    main()
