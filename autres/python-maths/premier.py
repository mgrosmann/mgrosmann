def est_premier(n):
    if n == 2:
         return(True)
    elif n <= 1 or n % 2 == 0:
        return(False)
    else:
        return(True)
nombre = int(input("Entrez un nombre : "))
print(est_premier(nombre))