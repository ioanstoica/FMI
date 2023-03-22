#include <iostream>
#include <fstream>

using namespace std;

class Point
{
public:
    long long x = 0, y = 0;
    Point() {}
    Point(long long x, long long y)
    {
        this->x = x;
        this->y = y;
    }

    bool operator<(const Point &other) const
    {
        if (x == other.x)
            return y < other.y;
        return x < other.x;
    }

    bool operator==(const Point &other) const
    {
        return x == other.x && y == other.y;
    }

    // overload the << operator to print a Point
    friend ostream &operator<<(ostream &os, const Point &p)
    {
        os << p.x << " " << p.y << endl;
        return os;
    }

    // overload the >> operator to read a Point
    friend istream &operator>>(istream &is, Point &p)
    {
        is >> p.x >> p.y;
        return is;
    }
};

class Triangle
{
public:
    Point A, B, C;
    // overload the >> operator to read a Triangle
    friend istream &operator>>(istream &is, Triangle &t)
    {
        is >> t.A >> t.B >> t.C;
        return is;
    }

    // overload the << operator to read a Triangle
    friend ostream &operator<<(ostream &os, const Triangle &t)
    {
        os << t.A << t.B << t.C;
        return os;
    }
};

int main()
{
    cout << "Hello world!" << endl;
    ifstream in("p1.in");
    // Read a triangle
    Triangle t;
    in >> t;
    int m;
    in >> m;
    while (m--)
    {
        // Read a point
        Point p;
        in >> p;
        // Check if the point is inside the circle determined by the triangle
        // If it is, print "INSIDE"
        // If in not, print "OUTSIDE"
        // If is on border, print "BOUNDARY"
        int matrix[3][3] = {{t.A.x, t.A.y, 1},
                            {t.B.x, t.B.y, 1},
                            {t.C.x, t.C.y, 1}};
    };

    return 0;
}