/// Var 4
/// Reuniunea dupa rang: Pentru fiecare multime tinem minte inaltimea arborelui care reprezinta acea multime
/// si atunci cand vrem sa unim 2 arbori, il unim pe cel mai mic de cel mai mare.
/// Compresia drumurilor
#include <bits/stdc++.h>
#define K 100002
using namespace std;

ifstream f("disjoint.in");
ofstream g("disjoint.out");

int t[K];
int tata(int x)
{
    if (t[x] == 0)
        return x;
    return tata(t[x]);
}
void compresie(int tt, int fiu)
{
    if (fiu == tt)
        return;
    t[fiu] = tt;
    compresie(tt, t[fiu]);
}
int main()
{
    int i, n, m, cod, x, y, tx, ty;
    f >> n >> m;
    for (i = 1; i <= n; i++)
        t[i] = 0;
    while (m--)
    {
        f >> cod >> x >> y;
        if (cod == 2)
            if (tata(x) == tata(y))
                g << "DA\n";
            else
                g << "NU\n";
        else
        {
            tx = tata(x);
            ty = tata(y);
            t[ty] = tx;
            compresie(tx, y);
        }
    }
}

// Complexitate: O(log*N)