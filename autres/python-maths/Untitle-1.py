def negative(L):
    m=[]
    for i in range(0, len(L)):
         if L[i] < 0:
            m.append(L[i])  
    return m
Z = [-1, 0, -99]
print(negative(Z))



