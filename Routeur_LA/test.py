# tentative de faire un arbre binaire en python
# a = [[v,t], fg, fd]

def getbit(a,i):
    if (a & int(2**(4-i))):
        return 1
    else:
        return 0

def estFeuille(a):
    return (len(a[1]) + len(a[2])) == 0

def mint(a1,a2):
    if len(a1) == 0:
        return a2[0][1]
    elif len(a2) == 0:
        return a1[0][1]
    else:
        return min(a1[0][1], a2[0][1])

def ajoute (a, ip, h, t):
    b = getbit(ip,h)
    if len(a) == 0:
        return [[ip, t], [], []]
    elif estFeuille(a):
        if b:
            a[2] = ajoute(a[2],ip,h+1,t)
            a = ajoute(a, a[0][0], h, a[0][1])
        else:
            a[1] = ajoute(a[1],ip,h+1,t)
            a = ajoute(a, a[0][0], h, a[0][1])
        a[0][1] = mint(a[1], a[2])
        return a
    else:
        if b:
            a[2] = ajoute(a[2],ip,h+1,t)
        else:
            a[1] = ajoute(a[1],ip,h+1,t)
        a[0][1] = mint(a[1], a[2])
        return a

def trouverLRU (a,t):
    if len(a) == 0:
        return -1
    else:
        if a[0][1] > t:
            return -1
        elif estFeuille(a):
            return a[0][0]
        else:
            m1 = trouverLRU(a[1],t)
            m2 = trouverLRU(a[2],t)
            return max(m1,m2)

def supNoeudInutile(a):
    if len(a[1]) == 0:
        if (len(a[2]) == 0) or estFeuille(a[2]):
            #ne pas oublier de free a[1] en ada
            return a[2]
        else:
            return a
    elif len(a[2]) == 0:
        if estFeuille(a[1]):
            #ne pas oublier de free a[2] en ada
            return a[1]
        else:
            return a
    else:
        return a

def supprimer(a,t):
    if len(a) == 0:
        return []
    else:
        if a[0][1] > t:
            return a
        elif estFeuille(a):
            #en ada faudra free
            return []
        else:
            a[1] = supprimer(a[1],t)
            a[2] = supprimer(a[2],t)
            a[0][1] = mint(a[1],a[2])
            return supNoeudInutile(a)

def fusionPrintStruct(l1, l2, n1, n2):
    if len(l1) + len(l2) == 0:
        return []

    la, lb = "", ""
    if l1:
        la = l1.pop()
    if l2:
        lb = l2.pop()

    na = (n1 - len(la))//2
    nb = (n2 - len(lb))//2

    l = " "*na + la + " "*na + " "*nb + lb + " "*nb
    L = fusionPrintStruct(l1,l2,n1,n2)
    L.append(l)
    return L

def printStructLa(a):
    if len(a) == 0:
        return ["    []    "]
    else:
        l1 = printStructLa(a[1])
        l2 = printStructLa(a[2])

        n1 = len(l1[-1])
        n2 = len(l2[-1])
        L = fusionPrintStruct(l1,l2,n1,n2)

        etiquette = str(a[0])
        N = n1 + n2//2 - 8
        etiquette = (" "*N) + etiquette + " "*((n2 - len(etiquette))//2)
        L.append(etiquette)
        return L


def printLA(a):
    L = printStructLa(a)
    while L:
        print(L.pop())

A =[]

A = ajoute(A,2,0,1)
A = ajoute(A,7,0,2)
A = ajoute(A,29,0,3)
A = ajoute(A,21,0,4)
A = ajoute(A,20,0,5)

printLA(A);
# print(A)
# print("--------")
# print(trouverLRU(A, A[0][1]))
# print("--------")
# A = supprimer(A, A[0][1])
# print(trouverLRU(A, A[0][1]))
# A = supprimer(A, A[0][1])
# A = supprimer(A, A[0][1])
# print(A)
# print(trouverLRU(A, A[0][1]))
# printLA(A)
# print("--------")
# A = supprimer(A, A[0][1])
# print(A)
