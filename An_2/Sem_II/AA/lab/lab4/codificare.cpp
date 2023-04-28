// https://cms.fmi.unibuc.ro/problem/genetici1
#include <bits/stdc++.h>

using namespace std;

string TO(double x, double a, double d, int l)
{
   string s;
   int n = (x - a) / d;
   for (int i = 0; i < l; i++)
   {
      s += (n % 2) + '0';
      n /= 2;
   }
   reverse(s.begin(), s.end());
   return s;
}

double FROM(string s, double a, double d, int l)
{
   int n = 0;
   for (int i = 0; i < l; i++)
      n = n * 2 + (s[i] - '0');
   return a + n * d;
}

int main()
{
   // ifstream cin("codificare.in");
   // ofstream cout("codificare.out");

   double a, b, p, l, d, x;
   int m;
   string tip, gena;
   cin >> a >> b >> p >> m;

   l = ceil(log2((b - a) * pow(10, p))); // numarul de biti necesari pentru a codifica un numar
   d = (b - a) / pow(2, l);              // pasul de discretizare

   while (m--)
   {
      cin >> tip;
      if (tip == "TO")
      {
         cin >> x;
         cout << TO(x, a, d, l) << endl;
         continue;
      }
      if (tip == "FROM")
      {
         cin >> gena;
         cout << fixed << setprecision(p + 1) << FROM(gena, a, d, l) << endl;
         continue;
      }
   }
}