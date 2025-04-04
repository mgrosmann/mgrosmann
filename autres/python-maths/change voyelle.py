def changevoyelles (ch):
    voyelles="aeiouy"
    nouvellechaine=""
    for i in ch:
        if i in voyelles:
            nouvellechaine=nouvellechaine+"?"
        else:
            nouvellechaine=nouvellechaine+i
    return nouvellechaine
test="résultat du programme : bravo vous avez reussi"
#print ( changevoyelles(test))        
     


def reverse_string(my_string):
    reversed_string = "".join(reversed(my_string))
    return reversed_string
my_string = "bonjour"
reversed_string = reverse_string(my_string)
#print(reversed_string)


def reverse_number(my_string):
    reversed_string = "".join(reversed(str(my_string)))
    return reversed_string
my_string0 = 12345
reversed_string = reverse_number(my_string0)
#print(reversed_string)


def occurence(ch,lettre):
    compteur=0
    for i in range(len(ch)):
        if ch[i]==lettre:
            compteur=compteur+1
    return (compteur)
chaine="vive les maths"
lettre='s'
#print(occurence(chaine, lettre))

def tableau_alphabet(ch):
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    tableau = []
    for lettre in alphabet:
        compteur = occurence(ch, lettre)
        tableau.append((lettre, compteur))
    
    lettre_max, occurence_max = max(tableau, key=lambda x: x[1])
    return tableau, lettre_max, occurence_max

tableau, lettre_max, occurence_max = tableau_alphabet("jskfdjlfsdjklfdljk")
#print("Tableau des occurrences de chaque lettre :", tableau)
#print("La lettre la plus fréquente est :", lettre_max, "avec", occurence_max, "occurrences.")







def nbplusfrequent(ch):
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    tableau = []
    for lettre in alphabet:
        compteur = occurence(ch, lettre)
        tableau.append((lettre, compteur))
    
    lettre_max, occurence_max = max(tableau, key=lambda x: x[1])
    return lettre_max, occurence_max

lettre_plus_frequente, occurence_max = nbplusfrequent("aaaaaaaaaaaaaaaa")
#print(f"\nLa lettre la plus fréquente est '{lettre_plus_frequente}' avec {occurence_max} occurrences.")
