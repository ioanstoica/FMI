// Stoica Ioan 251
// 26.01.2023
// Subiectul I
#include <iostream>
#include <list>
#include <map>
#include <fstream>
using namespace std;
map<long long, list<long long>> l;
long long n, m, m_aux, nr_cc, k, cnt = 2, cc[100000], cc_folosite[100000], necesare;
void DFS(long long x)
{
    list<long long>::iterator it;
    ///parcurg lista de adiacenta pt nodul curent
    for (it = l[x].begin(); it != l[x].end(); it++)
        ///daca nodul curent din lista este nevizitat atunci il trec ca vizitat si continui dfs-ul
        if (cc[*it] == 0 && *it!=0)
        {
            cc[*it] = cc[x];
            DFS(*it);
            *it = 0;
        }
}
struct muchie
{
    int x,y;
};
muchie cut[100000], paste[100000];
int main()
{
    /// citirea datelor
    long long i, j;
    ifstream f("graf.in");
    f>>n>>m;
    m_aux = m;
    while(m_aux)
    {
        ///introduc in lista de adiacenta valorile pt fiecare muchie citita
        f>>i>>j;
        l[i].push_back(j);
        l[j].push_back(i);
        m_aux--;
    }
    f>>k;
    f.close();

    /// cazul in care nu avem solutie:
    /// n noduri, k componente conexe, minim n-k muchii necesare
    if ( m < n-k )
    {
        cout<<"nu se poate";
        return 0;
    }

    for(i =1;i <=n; i++)
        if(cc[i] == 0 )
        {
            nr_cc++;
            cc[i] = nr_cc;
            DFS(i);
        }

    /// avem nr_cc componente conexe si vrea sa creeam k, deci o sa inlocuim nr_cc - k muchii
    necesare = nr_cc-k;
    /// aflam ce muchii trebuie sa adaugam
    cc_folosite[1] = 1;
    int cc_adaugam = 0;
    for(i =2;i<=n&&  cc_adaugam<=necesare;i++)
        if(cc_folosite[cc[i]] == 0 )
        {
            cc_folosite[cc[i]] =1;
            paste[++cc_adaugam].x=1;
            paste[cc_adaugam].y=i;
        }

    /// aflam ce muchii putem sa scoatem
    int cc_scoatem=0;
    list<long long>::iterator it;
    for(int x=1;x<=n && cc_scoatem<=necesare;x++)
        for (it = l[x].begin(); it != l[x].end(); it++)
            if ( *it!=0)
            {
                cut[++cc_scoatem].x=x;
                cut[cc_scoatem].y=*it;
            }

    cout<<"minimum "<<necesare<<" mutari cut-paste"<<endl;
    for(i=1;i<=necesare;i++)
        cout<<"("<<cut[i].x<<","<<cut[i].y<<") => ("<<paste[i].x<<","<<paste[i].y<<")"<<endl;

    return 0;
}

///Complexitate memorie: O(m+n)
///Complexitate timp: O(n+m)
