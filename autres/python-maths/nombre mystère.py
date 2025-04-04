import random

nombre_secret = random.randint(1, 10000)

while True:
    try:
        tentative = int(input("Devinez le nombre entre 1 et 10000 : "))
        if tentative == nombre_secret:
            print("Félicitations ! Vous avez deviné le nombre correctement.")
            break
        elif tentative < nombre_secret:
            print("Trop petit. Essayez à nouveau.")
        else:
            print("Trop grand. Essayez à nouveau.")
    except ValueError:
        print("Veuillez entrer un nombre valide.")

