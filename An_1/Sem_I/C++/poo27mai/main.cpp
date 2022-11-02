#include <iostream>
#include   <list>
using namespace std;

class Demo
{
    int x;
public:
        Demo(int a=100){x=a;}
        int get_x(){return x;}
};



int main()
{
    list <Demo*> z;
    z.push_back(new Demo(50));
    z.push_back(new Demo);
    z.push_back(new Demo(-15));
    z.sort();
    list <Demo*>::iterator i;
    for(i=z.begin(); i!= z.end(); ++i)
    {
        cout<<(*i)->get_x()<<" ";
    }


    return 0;
}
