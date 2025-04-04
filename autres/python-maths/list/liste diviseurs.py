def function_diviseurs(nb):
    diviseurs = []  
    for i in range(1, nb+1):  
        if nb % i == 0:  
            diviseurs.append(i)
    return diviseurs
print(function_diviseurs(100))
