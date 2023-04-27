#include <iostream>
#include <bits/stdc++.h>

using namespace std;

class A
{
public:
   int x;

   // overloaded operator +=
   void operator+=(const A &rhs)
   {
      x += rhs.x;
      // return *this;
   }
};

ostream &operator<<(ostream &os, const A &a)
{
   os << a.x;
   return os;
};

int main()
{
   cout << "Hello world!" << endl;
   A a, b;
   a.x = 1;
   b.x = 2;
   // cout << (a += b).x;
   a += b;
   cout << a << endl;
   return 0;
}