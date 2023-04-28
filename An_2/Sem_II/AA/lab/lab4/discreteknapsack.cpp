// https://cms.fmi.unibuc.ro/problem/discreteknapsack
#include <bits/stdc++.h>

using namespace std;

int main()
{
   // ifstream cin("discreteknapsack.in");
   // ofstream cout("discreteknapsack.out");

   int n, W;
   cin >> n >> W;
   int w[n], v[n];
   for (int i = 0; i < n; i++)
      cin >> v[i];
   for (int i = 0; i < n; i++)
      cin >> w[i];

   int dp[n + 1][W + 1];
   memset(dp, 0, sizeof(dp));

   for (int i = 1; i <= n; i++)
   {
      for (int j = 1; j <= W; j++)
      {
         if (w[i - 1] <= j)
            dp[i][j] = max(dp[i - 1][j], dp[i - 1][j - w[i - 1]] + v[i - 1]);
         else
            dp[i][j] = dp[i - 1][j];
      }
   }

   cout << dp[n][W];
   return 0;
}