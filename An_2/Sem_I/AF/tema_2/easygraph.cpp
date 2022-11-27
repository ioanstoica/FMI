// Stoica Ioan
// https://infoarena.ro/problema/easygraph
#include <iostream>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define MAX 15001

using namespace std;

int v[MAX];
vector<int> adjList[MAX];
int visited[MAX];

long long values[MAX];

void traversare(int node)
{
    visited[node] = 1;

    long long currentMax = -1;
    for (int i = 0; i < adjList[node].size(); i++)
    {
        int parentNode = adjList[node][i];
        // traversam parintele daca nu l-am vizitat
        if (!visited[parentNode])
            traversare(parentNode);
        if (values[parentNode] > currentMax)
            currentMax = values[parentNode];
    }

    if (currentMax > 0)
        values[node] = currentMax + v[node];
    else
        values[node] = v[node];
}

void test(int n, int m)
{

    for (int i = 1; i <= n; i++)
    {
        scanf("%d", &v[i]);
        adjList[i].clear();
        visited[i] = 0;
    }

    int from, to;
    for (int i = 0; i < m; i++)
    {
        scanf("%d %d", &from, &to);
        adjList[to].push_back(from);
    }

    long long maxVal = LONG_MIN;
    // traversam graful
    for (int i = 1; i <= n; i++)
    {
        if (!visited[i])
            traversare(i);
        if (values[i] > maxVal)
            maxVal = values[i];
    }

    printf("%lld\n", maxVal);
}

int main()
{
    freopen("easygraph.in", "r", stdin);
    freopen("easygraph.out", "w", stdout);

    int t, n, m;
    scanf("%d", &t);

    for (int i = 0; i < t; i++)
    {
        scanf("%d %d", &n, &m);
        test(n, m);
    }
    return 0;
}

// Complexity O(n*log m)
