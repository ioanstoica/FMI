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
    def __init__(self, start, scopuri, n, m):
        self.start = start  # informatia nodului de start
        self.scopuri = scopuri  # lista cu informatiile nodurilor scop

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def succesori(self, nodCurent):
        def conditie(mis,can):
            return mis >= can or mis == 0

        listaSuccesori = []
        
        if nodCurent.info[2] == 0:
            misMalCurent  =nodCurent.info[0]
            canMalCurent = nodCurent.info[1]
            misMalOpus = self.n - misMalCurent
            canMalOpus = self.m - canMalCurent
        else:
            misMalOpus = nodCurent.info[0]
            canMalOpus = nodCurent.info[1]
            misMalCurent = self.n - misMalOpus
            canMalCurent = self.m - canMalOpus
        maxMisBarca = min(misMalCurent, self.m)
        for misBarca in range(maxMisBarca):
            if misBarca == 0:
                minCanBarca = 1
                maxCanBarca = min(canMalCurent, self.m)
            else:
                minCanBarca = 0
                maxCanBarca = min(canMalCurent, self.m - misBarca, misBarca)
            for canBarca in range(minCanBarca, maxCanBarca + 1):
                misMalCurentNou = misMalCurent - misBarca
                canMalCurentNou = canMalCurent - canBarca
                misMalOpusNou = misMalOpus + misBarca
                canMalOpusNou = canMalOpus + canBarca
                if not conditie(misMalCurentNou, canMalCurentNou):
                    continue
                if not conditie(misMalOpusNou, canMalOpusNou):
                    continue
                if nodCurent.info[2] == 1:
                    nodNou = NodParcurgere((misMalCurentNou, canMalCurentNou, 0), nodCurent)
                else:
                    nodNou = NodParcurgere((misMalOpusNou, canMalOpusNou, 1), nodCurent)
                
                if not nodNou.vizitat():
                    listaSuccesori.append(nodNou)

        return listaSuccesori

    # o metoda scop(informatieNod) care primește o informație de nod și verifică dacă e nod scop
    def scop(self, informatieNod):
        return informatieNod in self.scopuri

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

# read n, m from file
with open("lab2.txt", "r") as f:
    Graph.n, Graph.m = [int(x) for x in f.readline().split()]

# create a new Graph
gr = Graph([Graph.n, Graph.n, 1], [[0, 0, 0]])

# print(gr.succesori(start))
breadth_first(gr)
