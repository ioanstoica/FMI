// https://cms.fmi.unibuc.ro/problem/l3p3
#include <bits/stdc++.h>

using namespace std;
using ll = long long;

class Dreapta
{
public:
   ll a, b, c;
   // Overload the >> operator
   friend istream &operator>>(istream &in, Dreapta &d)
   {
      in >> d.a >> d.b >> d.c;
      return in;
   }

   // Overload the << operator
   friend ostream &operator<<(ostream &out, Dreapta &d)
   {
      out << d.a << " " << d.b << " " << d.c;
      return out;
   }
};

int main()
{
   // ifstream cin("p3.in");
   ll n;
   cin >> n;
   // read n lines
   vector<Dreapta> v(n);
   for (ll i = 0; i < n; ++i)
      cin >> v[i];

   // sort the vector in 4 vectors
   vector<Dreapta> os, oj, vs, vd;
   for (auto &d : v)
   {
      if (d.a > 0 && d.b == 0)
         vs.push_back(d);
      else if (d.a < 0 && d.b == 0)
         vd.push_back(d);
      else if (d.a == 0 && d.b > 0)
         oj.push_back(d); // a * x + c <= 0    x <= -c / a
      else
         os.push_back(d);
   }
   // sort the vectors
   sort(os.begin(), os.end(), [](Dreapta &d1, Dreapta &d2)
        { return d1.c < d2.c; });
   sort(oj.begin(), oj.end(), [](Dreapta &d1, Dreapta &d2)
        { return d1.c > d2.c; });
   sort(vs.begin(), vs.end(), [](Dreapta &d1, Dreapta &d2)
        { return d1.c < d2.c; });
   sort(vd.begin(), vd.end(), [](Dreapta &d1, Dreapta &d2)
        { return d1.c > d2.c; });

   // if vs and vd are not empty, but the first element of vs is greater than the last element of vd, then the answer is "VOID"

   if (!vs.empty() && !vd.empty())
   {
      ll maxim = (-1) * vs[0].c;
      ll minim = vd.back().c;
      if (maxim < minim)
      {
         cout << "VOID";
         return 0;
      }
   }

   // if os and oj are not empty, but the first element of os is greater than the last element of oj, then the answer is "VOID"

   if (!os.empty() && !oj.empty())
   {
      ll maxim = (-1) * oj[0].c;
      ll minim = os.back().c;
      if (maxim < minim)
      {
         cout << "VOID";
         return 0;
      }
   }

   // if one vector is empty, then the answer is "UNBOUNDED"
   if (os.empty() || oj.empty() || vs.empty() || vd.empty())
   {
      cout << "UNBOUNDED";
      return 0;
   }

   // if the program reaches this point, then the answer is "BOUNDED"
   cout << "BOUNDED";

   return 0;
}