// https://cms.fmi.unibuc.ro/problem/l2p1
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

int main()
{
    // Se consideră un poligon convex cu
    // n vârfuri date în ordine trigonometrică (p1, p2, p3, ...pn) și
    // m puncte în plan (r1, r2, r3, ... rm).
    // Pentru fiecare dintre cele puncte să se stabilească dacă se află în interiorul, în exteriorul sau pe una dintre laturile poligonului.

    // read n from p1.in
    ifstream fin("p1.in");
    int n;
    fin >> n;
    // read n points from p1.in
    Point *p = new Point[n];
    for (int i = 0; i < n; i++)
        fin >> p[i];

    // read m from p1.in
    int m;
    fin >> m;
    // read m points from p1.in
    Point *r = new Point[m];
    for (int i = 0; i < m; i++)
        fin >> r[i];

    // close p1.in
    fin.close();
}