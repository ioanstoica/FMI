#include <iostream>
#include <algorithm>
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

long long det(Point P, Point Q, Point R)
{
    return P.x * Q.y + Q.x * R.y + R.x * P.y - P.y * Q.x - Q.y * R.x - R.y * P.x;
}
bool is_in_right(Point P, Point Q, Point R)
{
    return det(P, Q, R) > 0;
}

Point P[100002], Q1[100002], Q2[100002];

int main()
{
    // read t and t Points
    long long t;
    cin >> t;
    for (long long i = 0; i < t; i++)
        cin >> P[i];

    // Graham-Andrew
    // sort points by x, then by y, using sort from <algorithm>
    sort(P, P + t);

    // create a queue of points
    long long q1 = 0;
    // add first 2 points
    Q1[q1++] = P[0];
    Q1[q1++] = P[1];
    // for every point, add it to the queue
    // if it makes a right turn, remove the last point from the queue
    // and try again
    for (long long i = 2; i < t; i++)
    {
        Q1[q1++] = P[i];
        while (q1 > 2 && !is_in_right(Q1[q1 - 3], Q1[q1 - 2], Q1[q1 - 1]))
        {
            Q1[q1 - 2] = Q1[q1 - 1];
            q1--;
        }
    }

    // do same thing starting from the last point
    // and ending at the first point

    long long q2 = 0;
    // add last 2 points
    Q2[q2++] = P[t - 1];
    Q2[q2++] = P[t - 2];
    for (long long i = t - 2; i >= 0; i--)
    {
        Q2[q2++] = P[i];
        while (q2 > 2 && !is_in_right(Q2[q2 - 3], Q2[q2 - 2], Q2[q2 - 1]))
        {
            Q2[q2 - 2] = Q2[q2 - 1];
            q2--;
        }
    }

    // print results
    cout << q1 + q2 - 2 << endl;
    for (long long i = 1; i < q1; i++)
        cout << Q1[i];
    for (long long i = 1; i < q2; i++)
        cout << Q2[i];

    return 0;
}