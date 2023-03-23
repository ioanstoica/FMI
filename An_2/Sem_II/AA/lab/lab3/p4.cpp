// https://cms.fmi.unibuc.ro/problem/l3p4
#include <bits/stdc++.h>

using namespace std;
using ll = long long;
const double INF = 1e20;
const double EPS = 1e-20;

class Point
{
public:
   double x = 0, y = 0;
   Point() {}
   Point(ll x, ll y)
   {
      this->x = x;
      this->y = y;
   }

   friend ostream &operator<<(ostream &os, const Point &p)
   {
      os << "(" << p.x << "," << p.y << ")";
      return os;
   }

   friend istream &operator>>(istream &is, Point &p)
   {
      is >> p.x >> p.y;
      return is;
   }
};

class Semiplan
{
public:
   // a*x + b*y + c < 0
   ll a, b, c;

   friend istream &operator>>(istream &in, Semiplan &d)
   {
      in >> d.a >> d.b >> d.c;
      return in;
   }

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

unsigned int n, m;
vector<Semiplan> semiplane;
vector<Point> puncte;

void read_input()
{
   // ifstream cin("p4.in");

   // citire n semiplane
   cin >> n;
   semiplane.resize(n);
   for (unsigned int i = 0; i < n; ++i)
      cin >> semiplane[i];

   // citire m puncte
   cin >> m;
   puncte.resize(m);
   for (unsigned int i = 0; i < m; ++i)
      cin >> puncte[i];

   // cin.close();
};

void intern(vector<Semiplan> &semiplane, Point &p)
{
   IntersectieSemiplane intersectie;
   for (unsigned int i = 0; i < semiplane.size(); ++i)
      if (double(semiplane[i].a) * p.x + double(semiplane[i].b) * p.y + double(semiplane[i].c) < 0)
         intersectie.actualizare_limite(semiplane[i]);

   if (intersectie.tip() != "BOUNDED")
      cout << "NO" << endl;
   else
      cout << "YES" << endl;
}

void dreptunghi_interesant_minim(vector<Semiplan> &semiplane, Point &p)
{
   IntersectieSemiplane intersectie;
   for (unsigned int i = 0; i < semiplane.size(); ++i)
      if (double(semiplane[i].a) * p.x + double(semiplane[i].b) * p.y + double(semiplane[i].c) < 0)
         intersectie.actualizare_limite(semiplane[i]);

   if (intersectie.tip() != "BOUNDED")
      return;
   double aria = (intersectie.dreapta - intersectie.stanga) * (intersectie.sus - intersectie.jos);
   cout << setprecision(6) << aria << endl;
}

int main()
{
   read_input();

   for (unsigned int i = 0; i < m; ++i)
      intern(semiplane, puncte[i]);

   for (unsigned int i = 0; i < m; ++i)
      dreptunghi_interesant_minim(semiplane, puncte[i]);

   return 0;
}