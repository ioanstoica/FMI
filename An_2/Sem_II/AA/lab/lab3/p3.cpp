// https://cms.fmi.unibuc.ro/problem/l3p3
#include <bits/stdc++.h>

using namespace std;
using ll = long long;
const double INF = 1e9;

class Semiplan
{
public:
   // a*x + b*y + c < 0
   ll a, b, c;

   // Overload the >> operator
   friend istream &operator>>(istream &in, Semiplan &d)
   {
      in >> d.a >> d.b >> d.c;
      return in;
   }
   // Overload the << operator
   friend ostream &operator<<(ostream &out, Semiplan &d)
   {
      out << d.a << " " << d.b << " " << d.c;
      return out;
   }
   double lim() // pentru drepte verticale si orizontale
   {
      if (a == 0)
         return (-1) * double(c) / double(b);
      return (-1) * double(c) / double(a);
   }
};

class IntersectieSemiplane
{
public:
   double stanga = -INF, dreapta = INF, jos = -INF, sus = INF;

   void actualizare_limite(Semiplan &d)
   {
      if (d.a > 0 && d.b == 0) // a*x + c < 0 =>pt a pozitiv: x < -c/a => dreapta = min(-c/a, dreapta)
         dreapta = min(dreapta, d.lim());
      else if (d.a < 0 && d.b == 0) // a*x + c < 0 =>pt a negativ: x > -c/a => dreapta = max(-c/a, dreapta)
         stanga = max(stanga, d.lim());
      else if (d.a == 0 && d.b > 0) // b*y + c < 0 =>pt b pozitiv: y < -c/b => jos = min(-c/b, jos)
         sus = min(sus, d.lim());
      else
         jos = max(jos, d.lim());
   }

   string tip()
   {
      if (stanga > dreapta || jos > sus)
         return "VOID";

      if (stanga == -INF || dreapta == INF || jos == -INF || sus == INF)
         return "UNBOUNDED";

      return "BOUNDED";
   }
};

int main()
{
   // ifstream cin("p3.in");
   ll n;
   Semiplan semiplan;
   IntersectieSemiplane intersectie;

   cin >> n;

   for (ll i = 0; i < n; ++i)
   {
      cin >> semiplan;
      intersectie.actualizare_limite(semiplan);
   }

   cout << intersectie.tip();

   return 0;
}