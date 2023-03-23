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

// Semiplanul este definit prin dreapta ax + by + c = 0
class Semiplan
{
public:
   // a*x + b*y + c < 0 => punctul (x,y) apartine semiplanului
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

   bool contain(Point &p)
   {
      return a * p.x + b * p.y + c < 0;
   }
};

// Semiplane paralele cu axa Ox sau Oy
class IntersectieSemiplane
{
public:
   double stanga = -INF, dreapta = INF, jos = -INF, sus = INF;

   void intersectare(Semiplan &d)
   {
      if (d.a) // d.b == 0
      {
         if (d.a > 0)
            dreapta = min(dreapta, d.lim());
         else
            stanga = max(stanga, d.lim());
      }
      else // d.a == 0
      {

         if (d.b > 0)
            sus = min(sus, d.lim());
         else
            jos = max(jos, d.lim());
      }
   }

   string tip()
   {
      if (stanga > dreapta || jos > sus)
         return "VOID";

      if (stanga == -INF || dreapta == INF || jos == -INF || sus == INF)
         return "UNBOUNDED";

      return "BOUNDED";
   }

   double arie()
   {
      return (dreapta - stanga) * (sus - jos);
   }
};

unsigned int n, m;
vector<Semiplan> semiplane;
Point punct;

void get_dreptunghi(vector<Semiplan> &semiplane, Point &point)
{
   IntersectieSemiplane intersectie;
   for (auto &semiplan : semiplane)
      if (semiplan.contain(point))
         intersectie.intersectare(semiplan);

   if (intersectie.tip() != "BOUNDED")
   {
      cout << "NO" << endl;
      return;
   }

   cout << "YES" << endl;
   cout << setprecision(6) << fixed << intersectie.arie() << endl;
}

int main()
{
   // ifstream cin("p4.in");

   // citire n semiplane
   cin >> n;
   semiplane.resize(n);
   for (auto &semiplan : semiplane)
      cin >> semiplan;

   // citire m puncte
   cin >> m;
   while (m--)
   {
      cin >> punct;
      get_dreptunghi(semiplane, punct);
   }

   return 0;
}