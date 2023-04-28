#include <bits/stdc++.h>

using namespace std;

int main()
{
   // ifstream cin("mutatie.in");
   // ofstream cout("mutatie.out");

   int n, m, p;
   string gena;
   cin >> n >> m >> gena;

   while (m--)
   {
      cin >> p;
      gena[p] = (gena[p] == '0' ? '1' : '0');
   }

   cout << gena << '\n';
}