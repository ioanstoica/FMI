#include <iostream>
#include <fstream>
#include <map>
using namespace std;
int n,i,x,cod, k;
map <int,int> h;
int v[200001];
int main()
{
    ifstream f("heapuri.in");
    ofstream g("heapuri.out");
    f>>n;
    for(i=1;i<=n;i++)
    {
        f>>cod;
        if(cod != 3)
            f>>x;
        if(cod == 1)
        {
            h[x] = ++k ;
            v[k] = x;
        }
        if(cod == 2)
            h.erase(v[x]);
        if( cod == 3)
            g<<(h.begin()->first)<<"\n";
    }
    ///deleted(h[4]=1), h[7] = 2, h[9] = 3, cout<<4, deleted(h[2] = 4) , cout<<2, cout<<7
    f.close();
    g.close();
    return 0;
}
