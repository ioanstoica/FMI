#include <iostream>
#include <list>
#include <vector>


using namespace std;

int n, k, i, x, s, d;
int v[100002];

vector <list<int>> solve(int s,int d)
{
    vector <list<int>> sol;
    if (s==d)
    {
        list<int> aux;
        aux.push_back(s);
        sol.push_back(aux);
        return sol;
    }
    int mid = (a+b)/2;
    vector <list<int>> sol1 = solve(a, mid);
    vector <list<int>> sol2 = solve(mid+1, b);
}



int main()
{
    cin>>n;
    for(i=1;i<=n;i++)
        cin>>v[i];
    vector <list<int>> a = solve(1,n);

    for(auto &i:a)
    {
        for(auto &j:i)
            cout<<j<<" ";
        cout<<"\n";
    }
    return 0;
}
