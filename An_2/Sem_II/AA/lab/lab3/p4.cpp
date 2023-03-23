// https://cms.fmi.unibuc.ro/problem/l3p4
#include <bits/stdc++.h>

using namespace std;
const double INF = 1e13;

class Point
{
public:
   double x = 0, y = 0;
   Point() {}
   Point(double x, double y)
   {
      this->x = x;
      this->y = y;
   }

   friend ostream &operator<<(ostream &out, const Point &p)
   {
      out << "(" << p.x << "," << p.y << ")";
      return out;
   }

   friend istream &operator>>(istream &in, Point &p)
   {
      in >> p.x >> p.y;
      return in;
   }
};

class Semiplan
{
public:
   // a*x + b*y + c < 0
   double a, b, c;

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
         return -c / b;
      return -c / a;
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
      else if (d.a == 0 && d.b < 0) // b*y + c < 0 =>pt b negativ: y > -c/b => jos = max(-c/b, jos)
         jos = max(jos, d.lim());
      else
         cout << "Semiplanul nu este valid" << endl;
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
};

void solve(vector<Semiplan> &semiplane, Point &p)
{
   IntersectieSemiplane intersectie;
   for (unsigned int i = 0; i < semiplane.size(); ++i)
      if (semiplane[i].a * p.x + semiplane[i].b * p.y + semiplane[i].c < 0)
         intersectie.actualizare_limite(semiplane[i]);

   if (intersectie.tip() != "BOUNDED")
   {
      cout << "NO" << endl;
      return;
   }
   cout << "YES" << endl;
   double aria = (intersectie.dreapta - intersectie.stanga) * (intersectie.sus - intersectie.jos);
   cout << setprecision(6) << fixed << aria << endl;
}

int main()
{
   read_input();

   for (unsigned int i = 0; i < m; ++i)
      solve(semiplane, puncte[i]);

   return 0;
}