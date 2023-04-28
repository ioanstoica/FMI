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

   bool operator<(const Point &p) const
   {
      return y < p.y || (y == p.y && x < p.x);
   }
};

class Segment
{
public:
   Point A, B;
   Segment(Point A, Point B)
   {
      this->A = A;
      this->B = B;
   }

   double pozition(Point P)
   {
      return A.x * B.y + B.x * P.y + P.x * A.y - A.y * B.x - B.y * P.x - P.y * A.x;
   }

   bool in_line(Point P)
   {
      return pozition(P) == 0;
   }

   bool inside(Point P)
   {
      return in_line(P) && min(A.x, B.x) <= P.x && P.x <= max(A.x, B.x) && min(A.y, B.y) <= P.y && P.y <= max(A.y, B.y);
   }

   bool in_left(Point P)
   {
      return pozition(P) > 0;
   }

   bool in_right(Point P)
   {
      return pozition(P) < 0;
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

   bool onBoundery(Point Q)
   {
      for (unsigned int i = 0; i < points.size(); i++)
      {
         Point A = points[i];
         Point B = points[(i + 1) % points.size()];
         Segment s(A, B);
         if (s.inside(Q))
            return true;
      }
      return false;
   }

   string position(Point Q)
   {
      int poz = 0;
      for (unsigned int i = 0; i < points.size(); i++)
      {
         Point A = points[i];
         Point B = points[(i + 1) % points.size()];
         Segment s(A, B);
         if (s.inside(Q))
            return "BOUNDARY";
         if (A.y <= Q.y && Q.y < B.y && (B.x - A.x) * (Q.y - A.y) - (B.y - A.y) * (Q.x - A.x) > 0)
            poz++;
         if (B.y <= Q.y && Q.y < A.y && (B.x - A.x) * (Q.y - A.y) - (B.y - A.y) * (Q.x - A.x) < 0)
            poz--;
      }
      if (poz == 0)
         return "OUTSIDE";
      return "INSIDE";
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
      cout << polygon.position(Q) << '\n';
   }
}
