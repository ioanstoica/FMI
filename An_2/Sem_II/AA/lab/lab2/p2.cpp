// https://cms.fmi.unibuc.ro/problem/l2p2
#include <bits/stdc++.h>

using namespace std;

// Implementați un algoritm de complexitate de timp liniară care să determine poziția relativă a unui punct Q
//  față de un poligon arbitrar P1, P2, ..., Pn.

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

   // override the < operator to compare two points
   bool operator<(const Point &p) const
   {
      return y < p.y || (y == p.y && x < p.x);
   }
};

class Polygon
{
public:
   vector<Point> points;

   friend istream &operator>>(istream &in, Polygon &polygon)
   {
      int n;
      in >> n;
      polygon.points.resize(n);
      for (auto &point : polygon.points)
         in >> point;
      return in;
   }
};

int main()
{
   // ifstream cin("p2.in");
   // ofstream cout("p2.out");

   Polygon polygon;
   cin >> polygon;

   Point Q;
   int m;
   cin >> m;
   while (m--)
   {
      cin >> Q;
      // check if is on BOUNDARY
      bool isOnBoundary = false;
      for (int i = 0; i < polygon.points.size(); i++)
      {
         Point A = polygon.points[i];
         Point B = polygon.points[(i + 1) % polygon.points.size()];
         if (A.y <= Q.y && Q.y <= B.y && (B.x - A.x) * (Q.y - A.y) - (B.y - A.y) * (Q.x - A.x) == 0)
         {
            isOnBoundary = true;
            break;
         }
      }
      if (isOnBoundary)
      {
         cout << "BOUNDARY\n";
         continue;
      }

      int poz = 0;
      for (int i = 0; i < polygon.points.size(); i++)
      {
         Point A = polygon.points[i];
         Point B = polygon.points[(i + 1) % polygon.points.size()];
         if (A.y <= Q.y && Q.y < B.y && (B.x - A.x) * (Q.y - A.y) - (B.y - A.y) * (Q.x - A.x) > 0)
            poz++;
         if (B.y <= Q.y && Q.y < A.y && (B.x - A.x) * (Q.y - A.y) - (B.y - A.y) * (Q.x - A.x) < 0)
            poz--;
      }
      if (poz == 0)
         cout << "OUTSIDE\n";
      else
         cout << "INSIDE\n";
   }
}
