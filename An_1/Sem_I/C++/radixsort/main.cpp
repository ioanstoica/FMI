#include <iostream>
#include <fstream>
#include <algorithm>

using namespace std;

int v[10000001], aux[10000001];

int main()
{
    ifstream f("radixsort.in");
    ofstream g("radixsort.out");
    int N,A,B,C,i;
    f>>N>>A>>B>>C;

    v[1] = B;
    for (i=2;i<=N;i++)
        v[i] = (A*v[i-1]+B)%C;

    //sort(v+1,v+N+1);



    for(int poz =0; poz<= 30;poz++)/// bitul de comparatie  to do 31 vs 31
    {
        int bit = 1 << poz;
        int s=1,f=N;
        for(i=1;i<=N;i++)
            if ( (v[i] & bit) ==0)///daca numarul are bitul 0
                aux[s++] = v[i];
            else aux[f--] = v[i];
    }

    cout<< (1<<2);

    for(i=1;i<=N;i++)
        cout<<v[i]<<" ";

    f.close();
    g.close();
    return 0;
}
