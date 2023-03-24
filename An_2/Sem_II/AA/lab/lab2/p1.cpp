// https://cms.fmi.unibuc.ro/problem/l2p1
#include <bits/stdc++.h>

using namespace std;

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

// Convex Polygon with points in trigonometric order
class ConvexPolygon
{
public:
    int n;
    vector<Point> points;
    vector<Segment> segments;

    // override the >> operator to read a ConvexPolygon
    friend istream &operator>>(istream &in, ConvexPolygon &convex_polygon)
    {
        in >> convex_polygon.n;
        convex_polygon.points.resize(convex_polygon.n);
        for (auto &point : convex_polygon.points)
            in >> point;
        return in;
    }

    // override the << operator to print a ConvexPolygon
    friend ostream &operator<<(ostream &out, const ConvexPolygon &convex_polygon)
    {
        out << convex_polygon.n << endl;
        for (auto &point : convex_polygon.points)
            out << point << endl;
        return out;
    }

    string position(Point P)
    {
        for (auto &segment : segments)
        {
            if (segment.inside(P))
                return "BOUNDARY";
            if (segment.in_right(P))
                return "OUTSIDE";
        }
        return "INSIDE";
    }

    void create_segments()
    {
        for (int i = 0; i < n; i++)
            segments.push_back(Segment(points[i], points[(i + 1) % n]));
    }
};

int main()
{
    // ifstream cin("p1.in");
    ConvexPolygon convex_polygon;
    int m;
    Point point;

    // read a convex polygon
    cin >> convex_polygon;
    // create the segments
    convex_polygon.create_segments();

    // read and solve for m points
    cin >> m;
    while (m--)
    {
        cin >> point;
        cout << convex_polygon.position(point) << endl;
    }

    return 0;
}