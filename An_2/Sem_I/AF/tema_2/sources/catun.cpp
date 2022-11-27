// Stoica Ioan
// https://infoarena.ro/problema/catun

// Intr-un regat feudal exista mai multe asezari omenesti, numerotate de la 1 la N, intre care sunt construite drumuri de diverse lungimi. Dintre aceste asezari, o parte sunt fortarete, iar restul sunt simple catune. Fiecare fortareata trebuie sa aprovizioneze trupele stationate in ea, deci are nevoie de feude. In calitate de mare sfetnic al monarhului, vi se cere sa indicati feudele aservite fiecarei fortarete, respectiv toate acele catune care se afla mai aproape de fortareata in discutie decat de oricare alta. Daca un catun este la distanta egala de doua fortarete, se va considera ca apartine fortaretei cu numarul de identificare minim.

#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#define INF 10000000
using namespace std;

ifstream fin("catun.in");
ofstream fout("catun.out");

const int size = 36001;
int d[size];
priority_queue<int, vector<pair<int, int>>, greater<pair<int, int>>> heap;
vector<pair<int, int>> a[size];
int isFortress[size], fort[size];

void initializare(int n)
{
    for (int u = 1; u <= n; ++u)
    {
        d[u] = INF;
        isFortress[u] = 0;
        fort[u] = 0;
    }
}

int main()
{
    int i, n, m, x, y, c, k, s;
    fin >> n >> m >> k;
    initializare(n);
    for (i = 1; i <= k; ++i)
    {
        fin >> x;
        isFortress[x] = 1;
        d[x] = 0;
        heap.push(make_pair(0, x));
        fort[x] = x;
    }
    for (i = 1; i <= m; ++i)
    {
        fin >> x >> y >> c;
        a[x].push_back(make_pair(y, c));
        a[y].push_back(make_pair(x, c));
    }
    while (!heap.empty())
    {
        // cat timp mai avem ceva in heap
        int u = heap.top().second;
        heap.pop();
        for (auto v : a[u]) // parcurg vecinii lui u
            if (d[v.first] > d[u] + v.second || (d[v.first] == d[u] + v.second && fort[v.first] > fort[u]))
            {                                              // daca am gasit un drum mai scurt
                d[v.first] = d[u] + v.second;              // actualizez
                fort[v.first] = fort[u];                   // conectez la fortareata
                heap.push(make_pair(d[v.first], v.first)); // adaug in stiva
            }
    }
    for (i = 1; i <= n; ++i)
        if (isFortress[i] == 1 || fort[i] == 0)
            fout << 0 << " ";
        else
            fout << fort[i] << " ";
    return 0;
}

// Complexitate: O(n log n + m)