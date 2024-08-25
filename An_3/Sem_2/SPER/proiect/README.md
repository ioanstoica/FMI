Am ales tema 

    2.3 Parcurgere de puncte intermediare printr-o traiectorie Dubins
    Pentru o listă de puncte intermediare dată, construiți traiectoria formată din
primitive Dubins astfel încât să minimizați lungimea traiectoriei.
    Se cer următoarele:
    i) Alegeți ordinea de parcurgere a punctelor intermediare astfel încât să mini-
mizați lungimea traiectoriei (de exemplu printr-un algoritm de tipul trave-
ling salesman problem).
    ii) Ilustrați traiectoriile rezultate pentru diverse valori ale valorii de rază de
întoarcere minimă.
Indicație: Pentru generarea traiectoriei pentru o listă dată de puncte puteți, spre
exemplu, să folosiți codul din https://github.com/fgabbert/dubins_py
Dificultate: 3-4 persoane.

## Descriere
Proiectul constă în implementarea unui algoritm care să determine traiectoria optimă pentru a parcurge un set de puncte intermediare, folosind primitive Dubins.

## Daca pentru un punct, se schimba unghiul de plecare, se schimba si lungimea traiectoriei
ex:
Wptz = [Waypoint(0,0,0), 
    Waypoint(6000,7000,260), 
    Waypoint(1000,15000,180), 
    Waypoint(-5000,5000,270), 
    Waypoint(0,10000,180)]
si
Wptz = [Waypoint(0,0,0), 
        Waypoint(6000,7000,260), 
        Waypoint(1000,15000,180), 
        Waypoint(-5000,5000,270), 
        Waypoint(0,10000,0)]
    
Au traiectorii si distante diferite (45075 metri, respectiv 46979 metri)