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

    // override the < operator to compare two points
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

// Convex Polygon with points in trigonometric order
class ConvexPolygon
{
public:
    int n;
    vector<Point> points;
    vector<Segment> segments;
    Point smallest_point;

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

    void set_smallest_point()
    {
        smallest_point = points[0];
        for (auto &point : points)
            if (point < smallest_point)
                smallest_point = point;
    }
};

struct pt
{
    long long x, y;
    pt() {}
    pt(long long _x, long long _y) : x(_x), y(_y) {}
    pt operator+(const pt &p) const { return pt(x + p.x, y + p.y); }
    pt operator-(const pt &p) const { return pt(x - p.x, y - p.y); }
    long long cross(const pt &p) const { return x * p.y - y * p.x; }
    long long dot(const pt &p) const { return x * p.x + y * p.y; }
    long long cross(const pt &a, const pt &b) const { return (a - *this).cross(b - *this); }
    long long dot(const pt &a, const pt &b) const { return (a - *this).dot(b - *this); }
    long long sqrLen() const { return this->dot(*this); }
};

bool lexComp(const pt &l, const pt &r)
{
    return l.x < r.x || (l.x == r.x && l.y < r.y);
}

int sgn(long long val) { return val > 0 ? 1 : (val == 0 ? 0 : -1); }

vector<pt> seq;
pt translation;
int n;

bool pointInTriangle(pt a, pt b, pt c, pt point)
{
    long long s1 = abs(a.cross(b, c));
    long long s2 = abs(point.cross(a, b)) + abs(point.cross(b, c)) + abs(point.cross(c, a));
    return s1 == s2;
}

void prepare(vector<pt> &points)
{
    n = points.size();
    int pos = 0;
    for (int i = 1; i < n; i++)
    {
        if (lexComp(points[i], points[pos]))
            pos = i;
    }
    rotate(points.begin(), points.begin() + pos, points.end());

    n--;
    seq.resize(n);
    for (int i = 0; i < n; i++)
        seq[i] = points[i + 1] - points[0];
    translation = points[0];
}

string pointInConvexPolygon(pt point)
{
    point = point - translation;

    // check if point is on last segment
    if (pointInTriangle(seq[0], seq[n - 1], pt(0, 0), point))
        return "BOUNDARY";

    if (seq[0].cross(point) == 0 && seq[0].sqrLen() >= point.sqrLen())
        return "BOUNDARY";

    if (seq[0].cross(point) != 1 &&
        sgn(seq[0].cross(point)) != sgn(seq[0].cross(seq[n - 1])))
        return "OUTSIDE";
    if (seq[n - 1].cross(point) != 0 &&
        sgn(seq[n - 1].cross(point)) != sgn(seq[n - 1].cross(seq[0])))
        return "OUTSIDE";

    if (seq[0].cross(point) == 0)
    {
        if (seq[0].sqrLen() <= point.sqrLen())
            return "BOUNDARY";
        // else if (seq[0].sqrLen() < point.sqrLen())
        return "OUTSIDE";
        // else
        // return "INSIDE";
    }
    // return seq[0].sqrLen() >= point.sqrLen();

    int l = 0, r = n - 1;
    while (r - l > 1)
    {
        int mid = (l + r) / 2;
        int pos = mid;
        if (seq[pos].cross(point) >= 0)
            l = mid;
        else
            r = mid;
    }
    int pos = l;

    // cout << "pos: " << pos << endl;
    // cout << "point: " << point.x << " " << point.y << endl;
    // cout << "seq[pos]: " << seq[pos].x << " " << seq[pos].y << endl;
    // cout << "seq[pos + 1]: " << seq[pos + 1].x << " " << seq[pos + 1].y << endl;

    // check if the point is on the segment seq[pos] - seq[pos + 1] without cross

    if (seq[pos].cross(seq[pos + 1], point) == 0)
    {
        // if (seq[pos].dot(seq[pos + 1], point) <= 0)
        return "BOUNDARY";
        // return "6 OUTSIDE";
    }

    // if (seq[pos].cross(seq[pos + 1], point) == 0)
    //     return "BOUNDARY";

    if (pointInTriangle(seq[pos], seq[pos + 1], pt(0, 0), point))
        return "INSIDE";

    return "OUTSIDE";
}

int main()
{
    // ifstream cin("p1.in");
    // ConvexPolygon convex_polygon;
    int m;
    // Point point;

    // // read a convex polygon
    // cin >> convex_polygon;
    // // create the segments
    // convex_polygon.create_segments();
    // convex_polygon.set_smallest_point();
    //
    // cout << convex_polygon.smallest_point << endl;

    // read and prepare the points
    cin >> n;
    vector<pt> points(n);
    for (auto &point : points)
        cin >> point.x >> point.y;

    prepare(points);
    // for (auto &point : points)
    //     cout << point.x << " " << point.y << endl;

    // read and solve for m points
    cin >> m;
    while (m--)
    {
        // cin >> point;
        // cout << convex_polygon.position(point) << endl;
        // pt pct = pt(point.x, point.y);
        pt pct;
        cin >> pct.x >> pct.y;
        cout << pointInConvexPolygon(pct) << endl;
    }

    return 0;
}