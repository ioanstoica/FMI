#include <iostream>
#include <fstream>
#include <ctime>

using namespace std;

int v[500002], aux[500002];

void mergSort(int s, int f)
{
    if(f-s==1)
    {
        if( v[s] > v[f] )
            swap(v[s],v[f]);
    }
    if(f-s>=2)
    {

        int r = rand()%(f-s+1);
        int piv= v[s+r];
        int s1=s,f1=f;
        for(int i=s;i<=f;i++)
            if(v[i] < piv)
                aux[s1++] = v[i];
            else aux[f1--] = v[i];

        for(int i=s;i<=f;i++)
            v[i] = aux[i];
        mergSort(s,s1-1);
        mergSort(f1+1,f);///to do

    }
}

int main()
{
    ifstream f("algsort.in");
    ofstream g("algsort.out");
    int n;
    srand(time(0));
    f>>n;
    for (int i=1;i<=n;i++)
        f>>v[i];
    mergSort(1,n);
    for (int i=1;i<=n;i++)
        g<<v[i]<<" ";
    g.close();
    f.close();
    return 0;
}
