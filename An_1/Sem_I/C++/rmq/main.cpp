#include <iostream>
#include <fstream>
#include <math.h>       /* log */

using namespace std;

int n, m, v[200001], l, c, c1,c2 , p, i, j, a, b, d;
int i_min[20][100001]; /// i_min[l][c] = indexul valorii minime dintre pozitile  [i…i+2^j-1]

int main()
{
    cout << "Hello world!" << endl;
    ifstream f("rmq.in");
    ofstream g("rmq.out");

    f>>n>>m;
    for(i=1;i<=n;i++)
        f>>i_min[0][i] ;
    for(l = 1, p = 2; p <= n; l++, p = p<<1)
        for(c = 1; c<= n; c++)
            i_min[l][c] = min(i_min[l-1][c], i_min[l-1][c+ (p>>1) ]);
    for(j=1;j<=m;j++)
    {
        f>>a>>b;
        d = b-a+1; ///nr de elemente dintre a si b
        l = int(log2(d));
        c1 = a ;
        c2 = b - (1<<l) + 1;
        g<< min(i_min[l][c1], i_min[l][c2] )<<"\n";
    }

    f.close();
    g.close();
    return 0;
}
