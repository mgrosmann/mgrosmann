reponse=str(input("étes vous étudiant ?"))
if reponse== "o" or "n":
   age=int(input("Avez vous moins de 25 ans ?"))
   if age<25:
    print("Vous avez accès au tarif préférentiel")
else:
       print("Vous n'avez pas accès au tarif")
