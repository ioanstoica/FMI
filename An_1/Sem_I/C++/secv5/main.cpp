#include <iostream>
#include <fstream>
#include<vector>
#include<unordered_map>

int N,L,U;

using namespace std;

vector <long long> v;

unsigned long long solve(unsigned x){
	unordered_map<unsigned,int> val((1<<20)+10);
	unsigned l=0;
	unsigned long long sum=0;

	for(int i=0;i<N;i++){
		val[v[i]]++;
		while(val.size()>x){
			val[v[l]]--;
			if(val[v[l]]==0){
				val.erase(val.find(v[l]));
			}
			l++;
		}
		sum+=i-l+1;
	}
	return sum;
}

int main()
{
    ifstream f("secv5.in");
    ofstream g("secv5.out");
    int i;

    f>>N>>L>>U;
    v.resize(N);
    for(i=0; i<N; i++)
        f>>v[i];
    g<<solve(U)-solve(L-1);


    f.close();
    g.close();
    return 0;
}
