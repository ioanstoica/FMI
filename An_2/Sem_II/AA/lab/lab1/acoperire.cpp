#include <iostream>
#include <algorithm>
using namespace std;

// declare a Point structure
struct Point
{
    long long x;
    long long y;
};

// declare a function that calculates the determinant of a 3x3 matrix
bool isleft(Point P, Point Q, Point R)
{
    return P.x * Q.y + Q.x * R.y + R.x * P.y - P.y * Q.x - Q.y * R.x - R.y * P.x > 0;
}
Point P[100002];
Point Q1[100002];
Point Q2[100002];

int main()
{
    // read t and t Points
    long long t;
    cin >> t;

    for (long long i = 0; i < t; i++)
        cin >> P[i].x >> P[i].y;

    // Graham-Andrew
    // sort points by x, then by y, using sort from <algorithm>
    sort(P, P + t, [](Point a, Point b)
         {
        if (a.x == b.x)
            return a.y < b.y;
        return a.x < b.x; });

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
        while (q1 > 2 && !isleft(Q1[q1 - 3], Q1[q1 - 2], Q1[q1 - 1]))
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
        while (q2 > 2 && !isleft(Q2[q2 - 3], Q2[q2 - 2], Q2[q2 - 1]))
        {
            Q2[q2 - 2] = Q2[q2 - 1];
            q2--;
        }
    }
    // print the number of points in the queues
    cout << q1 + q2 - 2 << endl;

    // print Q1
    for (long long i = 1; i < q1; i++)
        cout << Q1[i].x << " " << Q1[i].y << endl;

    // print Q2
    for (long long i = 1; i < q2; i++)
        cout << Q2[i].x << " " << Q2[i].y << endl;

    return 0;
}