#include <iostream>
#include <fstream>
#include <list>
#include <math.h>

int const D = 100002;

using namespace std;

int n,m,i,x,y,p1,p2,r,k, a1, b1, sol_max, poz_crt, sol_p1, sol_p2, sol_crt, l, p,a,b,c,c1,c2;
int sef[D], tata[D], pct[D],val[D], walk_path[2*D], poz[2*D], depth[2*D], rmq[20][2*D]; //100000? !!! rmq
list <int> fii[32002];

void dfa(int r, int h)
{
    //cout<<h<<" ";
    depth[++k] = r;
    walk_path[k] = h;
    poz[r] = k;
    val[k] = r;
    for(auto &it:fii[r])
    {
        dfa(it,h+1);
        //cout<<h<<" ";
        depth[++k] = r;
        walk_path[k] = h;
        poz[r] = k;
        val[k] = r;
    }
}

int main()
{
    ifstream f("concurs.in");
    ofstream g("concurs.out");
    f>>n>>m; /// n - angajati si m - echipe
    for(i=1;i<=n;i++)
        f>>pct[i];
    for(i=1;i< n;i++)
    {
        f>>x>>y;
        tata[y] = x;
        fii[x].push_back(y);
    }
    for(i=1;i<=n;i++)
        if(tata[i] == 0)
        {
            r = i;
            break;
        }
    dfa(r,0);
    for(i=1;i<=k;i++)
        //rmq[0][i] = walk_path[i];
        rmq[0][i] = i;
    for(l=1, p=2; p<=k; l++, p = p<<1)
        for(c=1; c<=k; c++)
            if(walk_path[rmq[l-1][c]] < walk_path[rmq[l-1][c+(p>>1)]] )
                rmq[l][c] = rmq[l-1][c];
            else
                rmq[l][c] = rmq[l-1][c+(p>>1)];

    for(i=1;i<=m;i++)
    {
        f>>a>>b;
        a1 = a, b1 = b;
        a = poz[a]; b = poz[b];
        if(a>b)
            swap(a,b);
        l = int(log2(b-a+1));
        c1 = a;
        c2 = b - (1<<l) + 1 ;
        if(walk_path[rmq[l][c1]] < walk_path[rmq[l][c2]])
            poz_crt = rmq[l][c1];
        else
            poz_crt = rmq[l][c2];
        poz_crt = val[poz_crt];
        sol_crt = pct[poz_crt] ;
        //cout<<a<<" " <<b<<" "<<poz_crt<<endl;
        if(sol_crt > sol_max || ( sol_crt == sol_max && a1 < sol_p1) ||  ( sol_crt == sol_max && a1 == sol_p1 && b1 <sol_p2))/// trebuie aleasa solutia maxima, cu spec. din prob.
        {
            sol_max = sol_crt;
            sol_p1 = a1;
            sol_p2 = b1;
        }


    }

    g<<sol_max<<" "<<sol_p1<<" "<<sol_p2;

    f.close();
    g.close();
    return 0;
}
