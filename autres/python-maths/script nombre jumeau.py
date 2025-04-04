def mystere(n):
    compt=0
    for i in range(1, n+1):
        if n%i==0:
            compt=compt+1

    if compt==2:
        return(True)
    else:
        return(False)

print(mystere(20))




    
