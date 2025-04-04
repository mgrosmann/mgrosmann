salaire = 20000
annee=2016
salairetotal=20000
print ("En 2016, le salaire perçu est (en euros ): 2000")
for i in range(1,10):
    salaire = salaire *1.02
    annee = annee + 1
    salairetotal = salairetotal + salaire
print("En ",annee, " le salaire perçu est (en euros) :" ,(salaire))
print("Le salaire total des 10 années est ",salairetotal,)
          
    
