// https://cms.fmi.unibuc.ro/problem/l2p3
// Monotonia unui poligon
#include <bits/stdc++.h>

using namespace std;

// Implementați un algoritm de complexitate de timp liniară care să determine dacă un poligon P1, P2, ..., Pn
//  este monoton (strict) crescător sau descrescător.

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
   Point *x_min, *x_max, *y_min, *y_max;

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

   void set_min_max()
   {
      x_min = &points[0];
      x_max = &points[0];
      y_min = &points[0];
      y_max = &points[0];
      for (auto &point : points)
      {
         if (point.x < x_min->x)
            x_min = &point;
         if (point.x > x_max->x)
            x_max = &point;
         if (point.y < y_min->y)
            y_min = &point;
         if (point.y > y_max->y)
            y_max = &point;
      }
   }
};

int main()
{
   // Primul rând va indica dacă poligonul dat este
   // x-monoton, iar al doilea rând indică dacă este
   // y-monoton.

   // ifstream cin("p3.in");
   // ofstream cout("p3.out");

   Polygon polygon;
   cin >> polygon;

   polygon.set_min_max();

   // x-monoton
   if (polygon.x_min < polygon.x_max)
   {
      bool a1 = is_sorted(polygon.x_min, polygon.x_max,
                          [](Point a, Point b)
                          { return a.x < b.x; }); // creste pe x
      bool a2 = is_sorted(&polygon.points[0], polygon.x_min, [](Point a, Point b)
                          { return a.x > b.x; }); // scade pe x
      bool a3 = is_sorted(polygon.x_max, &polygon.points[polygon.points.size() - 1], [](Point a, Point b)
                          { return a.x > b.x; });
      if (a1 && a2 && a3)
         cout << "YES\n";
      else
         cout << "NO\n";
   }
   else
   {
      bool a1 = is_sorted(polygon.x_max, polygon.x_min,
                          [](Point a, Point b)
                          { return a.x > b.x; }); // scade pe x
      bool a2 = is_sorted(&polygon.points[0], polygon.x_max, [](Point a, Point b)
                          { return a.x < b.x; }); // creste pe x
      bool a3 = is_sorted(polygon.x_min, &polygon.points[polygon.points.size() - 1], [](Point a, Point b)
                          { return a.x < b.x; }); // creste pe x
      if (a1 && a2 && a3)
         cout << "YES\n";
      else
         cout << "NO\n";
   }

   // y-monoton
   if (polygon.y_min < polygon.y_max)
   {
      bool a1 = is_sorted(polygon.y_min, polygon.y_max,
                          [](Point a, Point b)
                          { return a.y < b.y; });
      bool a2 = is_sorted(&polygon.points[0], polygon.y_min, [](Point a, Point b)
                          { return a.y > b.y; });
      bool a3 = is_sorted(polygon.y_max, &polygon.points[polygon.points.size() - 1], [](Point a, Point b)
                          { return a.y > b.y; });
      if (a1 && a2 && a3)
         cout << "YES\n";
      else
         cout << "NO\n";
   }
   else
   {
      bool a1 = is_sorted(polygon.y_max, polygon.y_min,
                          [](Point a, Point b)
                          { return a.y > b.y; });
      bool a2 = is_sorted(&polygon.points[0], polygon.y_max, [](Point a, Point b)
                          { return a.y < b.y; });
      bool a3 = is_sorted(polygon.y_min, &polygon.points[polygon.points.size() - 1], [](Point a, Point b)
                          { return a.y < b.y; });
      if (a1 && a2 && a3)
         cout << "YES\n";
      else
         cout << "NO\n";
   }

   return 0;
}