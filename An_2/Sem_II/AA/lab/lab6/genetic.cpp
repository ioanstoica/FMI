#include <bits/stdc++.h>

using namespace std;

class Species
{
public:
   double a = 0, b = 0, c = 0;
   double left = 0, right = 0;
   double precision = 0;
   int nr_bits = 0;
   double step = 0;

   Species() {}
   Species(double a, double b, double c)
   {
      this->a = a;
      this->b = b;
      this->c = c;
   }

   double compute(double x)
   {
      return a * x * x + b * x + c;
   }

   friend istream &operator>>(istream &in, Species &species)
   {
      in >> species.a >> species.b >> species.c;
      return in;
   }

   double randomValue()
   {
      return (double)rand() / RAND_MAX * (right - left) + left;
   }

   string value_to_chromosome(double value)
   {
      string s;
      long long n = (value - left) / step;
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
      step = (right - left) / pow(2, nr_bits);
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
   double probability = 0;
   double left = 0, right = 0; // intervalul in care se afla cromozomul
   string chromosome = "";
   static Species species;

   Individual() {}

   // overloading =
   Individual &operator=(const Individual &other)
   {
      if (this == &other)
         return *this;
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

   double value()
   {
      return species.chromosome_to_value(chromosome);
   }

   double fitness()
   {
      return species.compute(value());
   }

   // overload <<
   friend ostream &operator<<(ostream &out, Individual &individual)
   {
      out << individual.chromosome << " " << individual.value() << " " << individual.fitness() << " " << individual.probability;
      return out;
   }
};

Species Individual::species;

class Population
{
public:
   vector<Individual> individuals;
   Species species;
   double sum = 0;
   int size = 0;
   double crossover_probability = 0;
   double mutation_probability = 0;
   int number_of_steps = 0;

   Population(){};

   void computeSum()
   {
      sum = 0;
      for (auto individual : individuals)
         sum += individual.fitness();
   }

   void computeProbabilitys()
   {
      for (auto &individual : individuals)
         individual.probability = individual.fitness() / sum;
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
      computeSum();
      computeProbabilitys();
      computeIntervals();
   }

   void randomInit()
   {
      individuals.resize(size);
      for (auto &individual : individuals)
         individual.chromosome = species.value_to_chromosome(species.randomValue());
   }

   // overloading <<
   friend ostream &operator<<(ostream &out, Population &population)
   {
      for (auto individual : population.individuals)
         out << fixed << setprecision(population.species.precision) << individual << endl;
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

   // selectie de noi indivizi, prin ruleta, in functie de probabilitatiile calculate deja
   void naturalSelection()
   {
      computeSelectie();
      vector<Individual> new_individuals;
      Individual best = individuals[0];
      for (auto individual : individuals)
         if (individual.fitness() > best.fitness())
            best = individual;
      new_individuals.push_back(best);
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

   void rareMutation()
   {
      for (auto &individual : individuals)
         if (&individual != &individuals[0]) // nu mutam cel mai bun individ
         {
            double p = (double)rand() / RAND_MAX;
            if (p > mutation_probability)
               continue;
            int index = rand() % individual.chromosome.size();
            if (individual.chromosome[index] == '0')
               individual.chromosome[index] = '1';
            else
               individual.chromosome[index] = '0';
         }
   }

   void normalMutation()
   {
      for (auto &individual : individuals)
         if (&individual != &individuals[0]) // nu mutam cel mai bun individ
         {
            for (int i = 0; i < individual.chromosome.size(); i++)
            {
               double p = (double)rand() / RAND_MAX;
               if (p > mutation_probability)
                  continue;
               if (individual.chromosome[i] == '0')
                  individual.chromosome[i] = '1';
               else
                  individual.chromosome[i] = '0';
            }
         }
   }
};

void menu(Population &population, Species &species)
{
   cout << "Alegeti una dintre optiunile pentru datele de intrare:\n";
   cout << "1. Folosirea datelor standard: s\n";
   cout << "2. Citire de la tastatura: t\n";
   cout << "3. Citire din fisier: f \n";

   char option = 's';
   // cin >> option;

   if (option == 't')
   {
      cout << "a = ";
      cin >> species.a;
      cout << "b = ";
      cin >> species.b;
      cout << "c = ";
      cin >> species.c;
      cout << "Capatul din stanga al intervalului de cautare: ";
      cin >> species.left;
      cout << "Capatul din dreapta al intervalului de cautare: ";
      cin >> species.right;
      cout << "Precizia: ";
      cin >> species.precision;
      cout << "Probabilitatea de crossover: ";
      cin >> population.crossover_probability;
      cout << "Probabilitatea de mutatie: ";
      cin >> population.mutation_probability;
      cout << "Numarul de pasi: ";
      cin >> population.number_of_steps;
      cout << "Dimensiunea populatiei: ";
      cin >> population.size;
      return;
   }

   if (option == 'f')
   {
      cout << "Dati numele fisierului: ";
      string file_name;
      cin >> file_name;
      ifstream cin(file_name);
      cin >> species.a;
      cin >> species.b;
      cin >> species.c;
      cin >> species.left;
      cin >> species.right;
      cin >> species.precision;
      cin >> population.crossover_probability;
      cin >> population.mutation_probability;
      cin >> population.number_of_steps;
      cin >> population.size;
      return;
   }

   if (option == 's')
   {
      cout << "Datele standard sunt:\n";
      cout << "a = " << species.a << endl;
      cout << "b = " << species.b << endl;
      cout << "c = " << species.c << endl;
      cout << "Capatul din stanga al intervalului de cautare: " << species.left << endl;
      cout << "Capatul din dreapta al intervalului de cautare: " << species.right << endl;
      cout << "Precizia: " << species.precision << endl;
      cout << "Probabilitatea de crossover: " << population.crossover_probability << endl;
      cout << "Probabilitatea de mutatie: " << population.mutation_probability << endl;
      cout << "Numarul de pasi: " << population.number_of_steps << endl;
      cout << "Dimensiunea populatiei: " << population.size << endl;
      return;
   }

   if (option == 's')
   {
      cout << "Datele standard sunt:\n";
      cout << "a = " << species.a << endl;
      cout << "b = " << species.b << endl;
      cout << "c = " << species.c << endl;
      cout << "Capatul din stanga al intervalului de cautare: " << species.left << endl;
      cout << "Capatul din dreapta al intervalului de cautare: " << species.right << endl;
      cout << "Precizia: " << species.precision << endl;
      cout << "Probabilitatea de crossover: " << population.crossover_probability << endl;
      cout << "Probabilitatea de mutatie: " << population.mutation_probability << endl;
      cout << "Numarul de pasi: " << population.number_of_steps << endl;
      cout << "Dimensiunea populatiei: " << population.size << endl;
      return;
   }
}

int main()
{
   srand(time(NULL));
   ofstream cout("genetic.out");

   Species species(-4, 100, 1); // a, b, c - parametri functiei de species ex; -x^2 + 2x + 1
   species.left = 0;            // capatul din stanga al intervalului de cautare -1
   species.right = 20;          // capatul din dreapta al intervalului de cautare 2
   species.precision = 6;       // 6 - nr de cifre dupa virgula

   Population population;
   population.crossover_probability = 0.25;
   population.mutation_probability = 0.01;
   population.number_of_steps = 50;
   population.size = 20;

   menu(population, species);

   species.intialize();
   Individual::species = species;
   population.species = species;
   population.randomInit();

   cout << "Initial population:\n"
        << population << endl;

   for (int i = 0; i < population.number_of_steps; i++)
   {
      population.naturalSelection();
      population.crossover();
      population.normalMutation();
      population.rareMutation();

      cout << "Step " << i << ":\n"
           << population << endl;
   }
}
