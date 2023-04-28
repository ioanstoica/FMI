// https://cms.fmi.unibuc.ro/problem/genetici3
#include <bits/stdc++.h>

using namespace std;

class Cromozom
{
public:
   string gena;
};

void incrucisare(Cromozom &x, Cromozom &y, int p)
{
   string x_aux = x.gena.substr(0, p) + y.gena.substr(p);
   string y_aux = y.gena.substr(0, p) + x.gena.substr(p);
   x.gena = x_aux;
   y.gena = y_aux;
}

int main()
{
   // ifstream cin("incrucisare.in");
   // ofstream cout("incrucisare.out");

   int n;
   cin >> n;

   Cromozom x, y;
   cin >> x.gena >> y.gena;

   int p;
   cin >> p;

   incrucisare(x, y, p);

   cout << x.gena << '\n'
        << y.gena << '\n';
}