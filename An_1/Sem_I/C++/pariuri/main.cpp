#include <iostream>
#include <fstream>
#include <map>
using namespace std;

int main()
{
    cout << "Hello world!" << endl;
    ifstream f("pariuri.in");
    ofstream g("pariuri.out");

    int N,M,i,j, timp, bani;
    map <int, int> p;
    //map <int, int> :: iterator it;

    f>>N;
    for(i=1;i<=N;i++)
    {
        f>>M;
        for(j=1;j<=M;j++)
        {
            f>>timp>>bani;
            p[timp] += bani;
        }
    }
    g<<p.size()<<"\n";
    for(auto& it: p)
        g<<it.first<<" "<<it.second<<" ";

    f.close();
    g.close();
    return 0;
}
