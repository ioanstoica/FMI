// https://cms.fmi.unibuc.ro/problem/genetici2
#include <bits/stdc++.h>

using namespace std;

class Fitness
{
private:
   int a = 0, b = 0, c = 0;

public:
   Fitness() {}
   Fitness(int a, int b, int c)
   {
      this->a = a;
      this->b = b;
      this->c = c;
   }

   double compute(double x)
   {
      return a * x * x + b * x + c;
   }

   friend istream &operator>>(istream &in, Fitness &fitness)
   {
      in >> fitness.a >> fitness.b >> fitness.c;
      return in;
   }
};

class Cromozom
{
public:
   double value = 0;
   double fitness = 0;
   double probability = 0;
   double left = 0, right = 0; // intervalul in care se afla cromozomul

   Cromozom() {}

   // overload >>
   friend istream &operator>>(istream &in, Cromozom &cromozom)
   {
      in >> cromozom.value;
      return in;
   }

   void computeFitness(Fitness &fitness)
   {
      this->fitness = fitness.compute(value);
   }
};

class GeneticAlgorithm
{
public:
   vector<Cromozom> cromozomi;
   Fitness fitness;
   double sum = 0;

   GeneticAlgorithm(){};

   friend istream &operator>>(istream &in, GeneticAlgorithm &ga)
   {
      int n;
      in >> ga.fitness;
      in >> n;
      ga.cromozomi.resize(n);
      for (auto &cromozom : ga.cromozomi)
         in >> cromozom;
      return in;
   }

   void computeFitness()
   {
      for (auto &cromozom : cromozomi)
         cromozom.computeFitness(fitness);
   }

   void computeSum()
   {
      for (auto cromozom : cromozomi)
         sum += cromozom.fitness;
   }

   void computeProbabilitys()
   {
      for (auto &cromozom : cromozomi)
         cromozom.probability = cromozom.fitness / sum;
   }

   void computeIntervals()
   {
      double left = 0;
      for (auto &cromozom : cromozomi)
      {
         cromozom.left = left;
         cromozom.right = left + cromozom.probability;
         left = cromozom.right;
      }
   }

   void computeSelectie()
   {
      computeFitness();
      computeSum();
      computeProbabilitys();
      computeIntervals();
   }
};

int main()
{
   // ifstream cin("selectie.in");
   // ofstream cout("selectie.out");

   GeneticAlgorithm ga;
   cin >> ga;

   ga.computeSelectie();

   for (auto &cromozom : ga.cromozomi)
      cout << fixed << setprecision(4) << cromozom.left << endl;
   cout << "1.0000" << endl;

   // cin.close();
   // cout.close();

   return 0;
}