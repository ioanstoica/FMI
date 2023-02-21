#include <iostream>

using namespace std;

// declare a Point structure
struct Point
{
    long long x;
    long long y;
};

int main()
{
    // read t, and t times read Points P,Q,R
    long long t;
    cin >> t;
    for (long long i = 0; i < t; i++)
    {
        Point P, Q, R;
        cin >> P.x >> P.y >> Q.x >> Q.y >> R.x >> R.y;
        // calculate determinant of matrix
        // | 1   1   1   |
        // | P.x Q.x R.x |
        // | P.y Q.y R.y |
        // if determinant is positive, print "LEFT"
        // if determinant is negative, print "RIGHT"
        // if determinant is zero, prlong long "TOUCH"
        long long det = P.x * Q.y + Q.x * R.y + R.x * P.y - P.y * Q.x - Q.y * R.x - R.y * P.x;
        if (det > 0)
            cout << "LEFT" << endl;
        else if (det < 0)
            cout << "RIGHT" << endl;
        else
            cout << "TOUCH" << endl;
    }

    return 0;
}