#include <iostream>
#include <fstream>
#include <unordered_map>

using namespace std;

long long v[10001];
long long N,M,A,B,C,D,E,i,ct,aux;

unordered_map <int, int> mymap;


void ver(int x)
{
    if(mymap.find(x) != mymap.end())
    {
        ct++;
        mymap.erase(x);
    }
}

int main()
{
    ifstream f("muzica.in");
    ofstream g("muzica.out");

    f>>N>>M; /// Melodii Vasile si DJ R
    f>>A>>B>>C>>D>>E;
    for (i=1; i<= N; i++)
    {
        f>>v[i];
        mymap[v[i]] = 1;
    }

    ver(A);
    ver(B);
    for(i=3;i<=M;i++)
    {
        aux = (C*B + D*A) % E;
        ver(aux);
        A = B;
        B = aux;
    }


    g<<ct;

    f.close();
    g.close();
    return 0;
}
