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

int main()
{
    // ifstream cin("p1.in");

    // read n points
    int n;
    cin >> n;
    vector<Point> poligon(n);
    for (auto &point : poligon)
        cin >> point;

    // create a vector of segments
    vector<Segment> segments;
    for (int i = 0; i < n; i++)
        segments.push_back(Segment(poligon[i], poligon[(i + 1) % n]));

    // read m points
    int m;
    cin >> m;
    vector<Point> points(m);
    for (auto &point : points)
        cin >> point;

    // for each point, check if it is in the convex hull
    for (auto &point : points)
    {
        bool ok = true;
        for (auto &segment : segments)
        {
            if (segment.inside(point))
            {
                ok = false;
                cout << "BOUNDARY" << endl;
                break;
            }

            if (segment.in_right(point))
            {
                ok = false;
                cout << "OUTSIDE" << endl;
                break;
            }
        }

        if (ok)
            cout << "INSIDE" << endl;
    }

    return 0;
}