// https://cms.fmi.unibuc.ro/problem/l3p2
#include <bits/stdc++.h>

using namespace std;
using ll = long long;

ll determinant(ll matrix[4][4], ll n)
{
    ll det = 0;
    ll submatrix[4][4];
    if (n == 2)
        return ((matrix[0][0] * matrix[1][1]) - (matrix[1][0] * matrix[0][1]));
    for (ll x = 0; x < n; x++)
    {
        ll subi = 0;
        for (ll i = 1; i < n; i++)
        {
            ll subj = 0;
            for (ll j = 0; j < n; j++)
            {
                if (j == x)
                    continue;
                submatrix[subi][subj] = matrix[i][j];
                subj++;
            }
            subi++;
        }
        det = det + (ll(pow(-1, x)) * matrix[0][x] * determinant(submatrix, n - 1));
    }
    return det;
}

class Point
{
public:
    ll x = 0, y = 0;
    Point() {}
    Point(ll x, ll y)
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

    // Check if a point is inside a circle determined by the triangle
    ll inside_circle(Point p)
    {
        ll matrix[4][4] = {{A.x, A.y, A.x * A.x + A.y * A.y, 1},
                           {B.x, B.y, B.x * B.x + B.y * B.y, 1},
                           {C.x, C.y, C.x * C.x + C.y * C.y, 1},
                           {p.x, p.y, p.x * p.x + p.y * p.y, 1}};

        return determinant(matrix, 4);
    }
};

int main()
{
    // ifstream cin("input.txt");
    // Read a triangle
    Triangle t;
    cin >> t;
    Point p;
    cin >> p;

    ll pos = t.inside_circle(p);

    if (pos == 0)
        cout << "AC: LEGAL" << endl
             << "BD: LEGAL" << endl;
    else if (pos < 0)
        cout << "AC: LEGAL" << endl
             << "BD: ILLEGAL" << endl;
    else
        cout << "AC: ILLEGAL" << endl
             << "BD: LEGAL" << endl;

    return 0;
}