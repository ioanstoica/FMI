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
    // read t and t Points
    long long t;
    cin >> t;
    Point P[t];
    for (long long i = 0; i < t; i++)
    {
        cin >> P[i].x >> P[i].y;
    }

    // for every 3 consecutive points, calculate determinant of matrix
    // | 1   1   1   |
    // | P.x Q.x R.x |
    // | P.y Q.y R.y |
    // if determinant is positive, left++
    // if determinant is negative, right++
    // if determinant is zero, touch++
    long long left = 0, right = 0, touch = 0;
    for (long long i = 0; i < t - 2; i++)
    {
        long long det = P[i].x * P[i + 1].y + P[i + 1].x * P[i + 2].y + P[i + 2].x * P[i].y - P[i].y * P[i + 1].x - P[i + 1].y * P[i + 2].x - P[i + 2].y * P[i].x;
        if (det > 0)
            left++;
        else if (det < 0)
            right++;
        else
            touch++;
    }
    /// do same thing for last 2 points and first point
    long long det = P[t - 2].x * P[t - 1].y + P[t - 1].x * P[0].y + P[0].x * P[t - 2].y - P[t - 2].y * P[t - 1].x - P[t - 1].y * P[0].x - P[0].y * P[t - 2].x;
    if (det > 0)
        left++;
    else if (det < 0)
        right++;
    else
        touch++;

    /// print the results
    cout << left << " " << right << " " << touch << endl;
    return 0;
}