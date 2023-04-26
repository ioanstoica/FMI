# informatii despre un nod din arborele de parcurgere (nu nod din graful initial)
class NodParcurgere:
    def __init__(self, info, parinte=None):
        self.info = info  # eticheta nodului, de exemplu: 0,1,2...
        self.parinte = parinte  # parintele din arborele de parcurgere

    def drumRadacina(self):
        l = []
        nod = self
        while nod:
            l.insert(0, nod)
            nod = nod.parinte
        return l


    def vizitat(self): #verifică dacă nodul a fost vizitat (informatia lui e in propriul istoric)
        nodDrum = self.parinte
        while nodDrum:
            if (self.info == nodDrum.info):
                return True
            nodDrum = nodDrum.parinte

        return False

    def __str__(self):
        return str(self.info)
    def __repr__(self):
        sir = str(self.info) + "("
        drum = self.drumRadacina()
        sir += ("->").join([str(n.info) for n in drum])
        sir += ")"
        return sir


class Graph:  # graful problemei

    def __init__(self, start, scopuri):
        self.start = start  # informatia nodului de start
        self.scopuri = scopuri  # lista cu informatiile nodurilor scop


    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def succesori(self, nodCurent):
        def conditie(mis, can):
            return mis == 0 or mis >= can
        listaSuccesori = []
        # (mis mal stang, can mal stang, locatie barca = 1 daca mal init si 0 daca mal final)
        # mal curent = mal cu barca
        # mal opus = mal fara barca

        if (nodCurent.info)[2] == 1: # mal curent = mal initial
            misMalCurent= nodCurent.info[0]
            canMalCurent = nodCurent.info[1]
            misMalOpus = Graph.N - nodCurent.info[0]
            canMalOpus = Graph.N - nodCurent.info[1]
        else: # mal curent = mal final
            misMalCurent= Graph.N - nodCurent.info[0]
            canMalCurent = Graph.N - nodCurent.info[1]
            misMalOpus = nodCurent.info[0]
            canMalOpus = nodCurent.info[1]

        maxMisBarca = min(misMalCurent, Graph.M)

        for misBarca in range(maxMisBarca + 1):
            if misBarca == 0:
                minCanBarca = 1
                maxCanBarca = min(canMalCurent, Graph.M)
            else:
                minCanBarca = 0
                maxCanBarca = min(canMalCurent, Graph.M - misBarca, misBarca)
            for canBarca in range(minCanBarca, maxCanBarca + 1):
                misMalCurentNou = misMalCurent - misBarca
                canMalCurentNou = canMalCurent - canBarca
                misMalOpusNou = misMalOpus + misBarca
                canMalOpusNou = canMalOpus + canBarca
                if not conditie(misMalCurentNou, canMalCurentNou):
                    continue
                if not conditie(misMalOpusNou, canMalOpusNou):
                    continue
                if (nodCurent.info)[2] == 1:
                    nodNou = NodParcurgere((misMalCurentNou, canMalCurentNou, 0), nodCurent)
                else:
                    nodNou = NodParcurgere((misMalOpusNou, Graph.N - canMalOpusNou, 1), nodCurent)

                if not nodNou.vizitat():
                    listaSuccesori.append(nodNou)
        return listaSuccesori

    def scop(self, infoNod):
        return infoNod == (0, 0, 0)



##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################



#### algoritm BF
# presupunem ca vrem mai multe solutii (un numar fix) prin urmare vom folosi o variabilă numită nrSolutiiCautate
# daca vrem doar o solutie, renuntam la variabila nrSolutiiCautate
# si doar oprim algoritmul la afisarea primei solutii

def breadth_first(gr, nrSolutiiCautate=1):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start)]

    while len(c) > 0:
        #print("Coada actuala: " + str(c))
        #input()
        nodCurent = c.pop(0)

        if gr.scop(nodCurent.info):
            print("Solutie:")
            drum = nodCurent.drumRadacina()
            print(("->").join([str(n.info) for n in drum]))
            print("\n----------------\n")
            #input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        c+=gr.succesori(nodCurent)


def depth_first(gr, nrSolutiiCautate=1):
    # vom simula o stiva prin relatia de parinte a nodului curent
    df(NodParcurgere(gr.start), nrSolutiiCautate)


def df(nodCurent, nrSolutiiCautate):
    if nrSolutiiCautate <= 0:  # testul acesta s-ar valida doar daca in apelul initial avem df(start,if nrSolutiiCautate=0)
        return nrSolutiiCautate
    #print("Stiva actuala: " + repr(nodCurent.drumRadacina()))
    #input()
    if gr.scop(nodCurent.info):
        print("Solutie: ", end="")
        drum = nodCurent.drumRadacina()
        print(("->").join([str(n.info) for n in drum]))
        print("\n----------------\n")
        #input()
        nrSolutiiCautate -= 1
        if nrSolutiiCautate == 0:
            return nrSolutiiCautate
    lSuccesori = gr.succesori(nodCurent)
    for sc in lSuccesori:
        if nrSolutiiCautate != 0:
            nrSolutiiCautate = df(sc, nrSolutiiCautate)

    return nrSolutiiCautate


# df(a)->df(b)->df(c)->df(f)
#############################################


def df_nerecursiv(nrSolutiiCautate):
    stiva = [NodParcurgere(gr.start)]
    #consider varful stivei in dreapta
    while stiva: #cat timp stiva nevida
        nodCurent=stiva.pop() #sterg varful
        if gr.scop(nodCurent.info):
            print("Solutie:")
            drum = nodCurent.drumRadacina()
            print(("->").join([str(n.info) for n in drum]))
            print("\n----------------\n")
            #input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        stiva+=gr.succesori(nodCurent)[::-1] #adaug in varf succesoii in ordine inversa deoarece vreau sa expandez primul succesor generat si trebuie sa il pun in varf

"""
Mai jos puteti comenta si decomenta apelurile catre algoritmi. Pentru moment e apelat doar breadth-first
"""

with open("lab2.txt", "r") as f:
    Graph.N, Graph.M = [int(x) for x in f.readline().split()]

print(Graph.N, Graph.M)

start = (Graph.N, Graph.N, 1)
scopuri = [(0, 0, 0)]
gr = Graph(start, scopuri)

print(gr.succesori(NodParcurgere((3, 2, 1))))

# start = NodParcurgere((N, N, 1))

# nod1 = NodParcurgere(())


breadth_first(gr, nrSolutiiCautate=2)

depth_first(gr, nrSolutiiCautate=2)