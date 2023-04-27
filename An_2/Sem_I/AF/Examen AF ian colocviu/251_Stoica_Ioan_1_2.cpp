// Stoica Ioan 251
// 26.01.2023
// Subiectul II
#include <iostream>
#include <list>
#include <map>
#include <fstream>
using namespace std;
struct muchie
{
    long long sursa,dest,cost;
    bool viz;
};

map<long long, list<muchie>> l;
long long n, m, m_aux, nr_cc, k, cnt = 2, cc[100000], cc_folosite[100000], necesare, ajung[100000], q[100000], waiting, cost_max[100000], sol[100000], dim_sol, last_fr[100000];

using namespace std;

void parcurgere(long long x)
{
    list<muchie>::iterator it;
    ///parcurg lista de adiacenta pt nodul curent
    for (it = l[x].begin(); it != l[x].end(); it++)
    {
        ///daca nodul curent din lista este nevizitat atunci il trec ca vizitat si continui parcurgerea-ul
        muchie aux = (*it);
        if ( (*it).viz == false )
        {
            /// actualizare cost
            if(cost_max[(*it).dest] < cost_max[(*it).sursa] + (*it).cost && (*it).cost <= k )
            {
                cost_max[(*it).dest] = cost_max[(*it).sursa] + (*it).cost;
                last_fr[(*it).dest] = (*it).sursa;
            }

            (*it).viz = true;
            ajung[(*it).dest] -- ;
            if(ajung[(*it).dest] == 0)
                q[++waiting] = (*it).dest;
        }
    }

}

int main()
{
    /// citirea datelor
    long long i, j, cost;
    ifstream f("graf.in");
    f>>n>>m;
    m_aux = m;
    muchie mch;
    while(m_aux)
    {
        ///introduc in lista de adiacenta valorile pt fiecare muchie citita
        f>>i>>j>>cost;
        ajung[j]++;
        mch.dest=j;
        mch.sursa = i;
        mch.cost=cost;
        mch.viz= false;
        l[i].push_back(mch);
        m_aux--;
    }
    f>>k;
    f.close();
    /// ignporam mcuhiile cu cost > k

    for(i =0;i <n; i++)
        if(ajung[i] ==0)
            q[++waiting] = i;

    /// facem parcurgere de la aceste varfuri
    while(waiting){
       waiting--;
        parcurgere(q[waiting+1]);
    }

    long long cost_final_max = 0;
    long long p_final;
    for(i=0;i<n;i++)
        if(cost_final_max < cost_max[i])
        {
            cost_final_max = cost_max[i];
            p_final = i;
        }


    cout<<"Costul este: " << cost_final_max <<endl;

    //while(cost_max[p_final]!=0 )



    /// oentru fiecare muchie pe care putem merge, actualizam costul si adaugam varfurile noi in lista

}
