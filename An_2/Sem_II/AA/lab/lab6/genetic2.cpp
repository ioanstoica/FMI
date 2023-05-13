#include <bits/stdc++.h>

using namespace std;

class Fitness
{
public:
   double a = 0, b = 0, c = 0;
   double left = 0, right = 0;
   double precision = 0;
   int nr_bits = 0;
   double step = 0;

   Fitness() {}
   Fitness(double a, double b, double c)
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

   double randomValue()
   {
      return (double)rand() / RAND_MAX * (right - left) + left;
   }

   string value_to_chromosome(double value)
   {
      string s;
      int n = (value - left) / step;
      for (int i = 0; i < nr_bits; i++)
      {
         s += (n % 2) + '0';
         n /= 2;
      }
      reverse(s.begin(), s.end());
      return s;
   }

   void intialize()
   {
      nr_bits = ceil(log2((right - left) * pow(10, precision)));
      step = (right - left) / (1 << nr_bits);
   }

   double chromosome_to_value(string chromosome)
   {
      double value = 0;
      for (int i = 0; i < nr_bits; i++)
         value = 2 * value + (chromosome[i] - '0');
      return value * step + left;
   }
};

class Individual
{
public:
   double value = 0;
   double fitness = 0;
   double probability = 0;
   double left = 0, right = 0; // intervalul in care se afla cromozomul
   string chromosome = "";

   Individual() {}

   // overload >>
   friend istream &operator>>(istream &in, Individual &individual)
   {
      in >> individual.value;
      return in;
   }

   void computeFitness(Fitness &fitness)
   {
      this->fitness = fitness.compute(fitness.chromosome_to_value(chromosome));
   }

   // overloading =
   Individual &operator=(const Individual &other)
   {
      if (this == &other)
         return *this;
      value = other.value;
      fitness = other.fitness;
      probability = other.probability;
      left = other.left;
      right = other.right;
      chromosome = other.chromosome;
      return *this;
   }

   void crossover(Individual &other)
   {
      int index = rand() % chromosome.size();
      string s1 = chromosome.substr(0, index) + other.chromosome.substr(index);
      string s2 = other.chromosome.substr(0, index) + chromosome.substr(index);
      chromosome = s1;
      other.chromosome = s2;
   }

   // overloading <<
   friend ostream &operator<<(ostream &out, Individual &individual)
   {
      out << individual.chromosome << " " << individual.value << " " << individual.fitness << " " << individual.probability;
      return out;
   }
};

class Population
{
public:
   vector<Individual> individuals;
   Fitness fitness;
   double sum = 0;
   int size = 0;
   double crossover_probability = 0;
   double mutation_probability = 0;
   int number_of_steps = 0;

   Population(){};

   friend istream &operator>>(istream &in, Population &Population)
   {
      int n;
      in >> Population.fitness;
      in >> n;
      Population.individuals.resize(n);
      for (auto &individual : Population.individuals)
         in >> individual;
      return in;
   }

   void computeFitness()
   {
      for (auto &individual : individuals)
         individual.computeFitness(fitness);
   }

   void computeSum()
   {
      sum = 0;
      for (auto individual : individuals)
         sum += individual.fitness;
   }

   void computeProbabilitys()
   {
      for (auto &individual : individuals)
         individual.probability = individual.fitness / sum;
   }

   void computeIntervals()
   {
      double left = 0;
      for (auto &individual : individuals)
      {
         individual.left = left;
         individual.right = left + individual.probability;
         left = individual.right;
      }
   }

   void computeSelectie()
   {
      computeFitness();
      computeSum();
      computeProbabilitys();
      computeIntervals();
   }

   void randomInit()
   {
      individuals.resize(size);
      for (auto &individual : individuals)
      {
         individual.value = fitness.randomValue();
         individual.chromosome = fitness.value_to_chromosome(individual.value);
      }
   }

   // overloading <<
   friend ostream &operator<<(ostream &out, Population &Population)
   {
      for (auto individual : Population.individuals)
         out << individual << endl;
      return out;
   }

   void crossover()
   {
      bool pereche = false;
      Individual *first;
      for (auto &individual : individuals)
      {
         double p = (double)rand() / RAND_MAX;
         if (p > crossover_probability)
            continue;

         if (pereche)
         {
            individual.crossover(*first);
            pereche = false;
         }
         else
         {
            first = &individual;
            pereche = true;
         }
      }
   }

   // selectie ne indivizi, prin ruleta, in functie de probabilitatiile calculate deja
   void naturalSelection()
   {
      vector<Individual> new_individuals;
      Individual best = individuals[0];
      for (auto individual : individuals)
         if (individual.fitness > best.fitness)
            best = individual;
      new_individuals.push_back(best); // aici ar trebuii adaugat cel mai bun individ
      for (int i = 1; i < size; i++)
      {
         double p = (double)rand() / RAND_MAX;
         int index = 0;
         while (individuals[index].right < p)
            index++;
         new_individuals.push_back(individuals[index]);
      }

      for (int i = 0; i < size; i++)
         individuals[i] = new_individuals[i];
   }

   void randomSelect(Population old_population, double select_probability)
   {
      for (auto individual : old_population.individuals)
      {
         double p = (double)rand() / RAND_MAX;
         if (p < select_probability)
            individuals.push_back(individual);
      }
   }
};

int main()
{
   srand(time(NULL));
   ofstream cout("genetic.out");

   Fitness fit(-1, 1, 2); // a, b, c - parametri functiei de fitness
   fit.left = -1;         // capatul din stanga al intervalului de cautare
   fit.right = 2;         // capatul din dreapta al intervalului de cautare
   fit.precision = 6;     // 6
   fit.intialize();

   Population population;
   population.fitness = fit;
   population.crossover_probability = 0.25;
   population.mutation_probability = 0.01;
   population.number_of_steps = 50;
   population.size = 20;

   population.randomInit();

   cout << "Initial population:\n"
        << population << endl;

   for (int i = 0; i < population.number_of_steps; i++)
   {
      population.computeSelectie();
      population.naturalSelection();
      population.crossover();

      cout << "Step " << i << ":\n";
      cout << "Populatia dupa crossover:\n"
           << population << endl;
   }
}
