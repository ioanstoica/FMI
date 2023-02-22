# Definiți o clasa Nod, care va reprezenta un nod dintr-un arbore de parcurgere, cu câmpurile: informatie, parinte. In constructor, vom defini pentru parinte ca valoare implicită None. Clasa Nod va avea următoarele metode:

class Nod:
    def __init__(self, informatie, parinte=None):
        self.informatie = informatie
        self.parinte = parinte

    # drumRadacina() care va returna o listă cu toate nodurile de la rădăcină până la nodul curent
    def drum_radacina(self):
        x = self
        l = []
        while x:
            l.append(x)
            x = x.parinte
        return l[::-1]

    # vizitat() care verifică dacă nodul a fost vizitat pe drumul curent (deci nu în tot arborele) caz în care returnează True, altfel (dacă nu a fost vizitat) False. Reformulat: dacă informația se mai găsește în drumul de dinaintea nodului curent, returnăm True.
    def vizitat(self):
        x = self.parinte
        while x:
            if x.informatie == self.informatie:
                return True
            x = x.parinte
        return False
    
    # funcția __repr__  care va returna un string continand informatia nodului, urmata de un spatiu, urmat de o paranteză în care se află tot drumul de la rădăcină până la acel nod). De exemplu "c (a->b->c)"
    def __repr__(self):
        return f"{self.informatie} ({'->'.join([str(x) for x in self.drum_radacina()])})"

    def __str__(self):
        return f"{self.informatie}"
    
# Definiți o clasă Graf, în care se va memora un graf (alegeți voi dacă prin listă de vecini, matrice de adiacența, sau listă de noduri și muchii), inclusiv nodul start și nodurile scop (date ca lista de informații scop).
class Graf:
    # listă de vecini
    def __init__(self, nodes, matrix, start, scop):
        self.nodes = nodes
        self.matrix = matrix
        self.start = start
        self.scop = scop

    # o metoda scop(informatieNod) care primește o informație de nod și verifică dacă e nod scop
    def scop(self, informatieNod):
        return informatieNod in self.scop
    
    # o metoda (care va fi folosită în algoritmi pentru generarea arborelui de căutare), numită  succesori(nod) care primește un nod al arborelui de parcurgere și parcurge nodurile adiacente din graf, returnand o lista de obiecte de clasa Nod ce reprezinta sucesori direcți ai nodului (care vor fi fii în arborele de căutare), care nu au fost vizitati pe ramura curentă.
    def succesori(self, nod):
        l = []
        for i in range(self.nodes):
            if self.matrix[nod.informatie][i] == 1 and not nod.vizitat():
                l.append(Nod(i, nod))
        return l
    
    # Implementați tehnica de căutare Breadthfirst, folosind clasele Nod și Graf definite mai sus.
    def breadthfirst(self, NSOL):
        # lista de noduri de vizitat
        l = [Nod(self.start)]
        # lista de noduri vizitate
        v = []
        while l:
            # extragem primul nod din lista de noduri de vizitat
            x = l.pop(0)
            # verificam daca nodul este nod scop
            if self.scop(x.informatie):
                return x.drum_radacina()
            # adaugam nodul in lista de noduri vizitate
            v.append(x)
            # adaugam nodurile succesori in lista de noduri de vizitat
            l.extend(self.succesori(x))
        return []

    # Implementați tehnica de căutare DepthFirst, folosind clasele Nod și Graf definite mai sus, în mod recursiv.
    def depthfirst(self, NSOL):
        # lista de noduri de vizitat
        l = [Nod(self.start)]
        # lista de noduri vizitate
        v = []
        while l:
            # extragem primul nod din lista de noduri de vizitat
            x = l.pop(0)
            # verificam daca nodul este nod scop
            if self.scop(x.informatie):
                return x.drum_radacina()
            # adaugam nodul in lista de noduri vizitate
            v.append(x)
            # adaugam nodurile succesori in lista de noduri de vizitat
            l.extend(self.succesori(x))
        return []

    

# testare
if __name__ == "__main__":
    # ex 1    
    n = Nod(1, Nod(2, Nod(3)))
    print(n)
    print(n.drum_radacina())
    print(n.vizitat())

    # testare graf
    n = 5
    m = [[0, 1, 1, 0, 0],
        [1, 0, 0, 1, 0],
        [1, 0, 0, 1, 0],
        [0, 1, 1, 0, 1],
        [0, 0, 0, 1, 0]]
    g = Graf(5, m, 0, [4])
    print("Succesori nod 1: ")
    print(g.succesori(Nod(1)))

    # ex 2
    NSOL = 3
    # testare breadthfirst
    l = g.breadthfirst()
    
    
