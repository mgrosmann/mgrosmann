def est_narcissique(nombre):
    return sum(int(chiffre) ** len(str(nombre)) for chiffre in str(nombre)) == nombre

print(est_narcissique(153))