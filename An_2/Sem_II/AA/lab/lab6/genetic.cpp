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
      double fitness = a * x * x + b * x + c;
      if (fitness > 0)
         return fitness;
      string error = "Fitness-ul trebuie sa fie strict pozitiv: pentru a=" + to_string(a) + ", b=" + to_string(b) + ", c=" + to_string(c) + ", x=" + to_string(x) + ", fitness = a * x * x + b * x + c =" + to_string(fitness) + "\n";
      throw error;
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

   void crossover(Individual &other, string &out)
   {
      int index = rand() % chromosome.size();

      out += "Cromozomii care se incruciseaza sunt: \n" + chromosome + "\n" + other.chromosome + "\n";
      out += "Punctul de incrucisare este bit-ul: " + to_string(index) + "\n";

      string s1 = chromosome.substr(0, index) + other.chromosome.substr(index);
      string s2 = other.chromosome.substr(0, index) + chromosome.substr(index);
      chromosome = s1;
      other.chromosome = s2;

      out += "Rezultatul este: \n" + chromosome + "\n" + other.chromosome + "\n";
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
      out << individual.toString();
      return out;
   }

   string toString()
   {
      return "biti=" + chromosome + ", x=" + to_string(value()) + ", f(x)=" + to_string(fitness()) + ", prob=" + to_string(probability) + ", interval selectie=(" + to_string(left) + ", " + to_string(right) + ")";
   }

   bool operator<(Individual &other)
   {
      return fitness() < other.fitness();
   }
};

Species Individual::species;

class Population
{
public:
   vector<Individual> individuals;
   static Species species;
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

   string toString()
   {
      string out;
      int i = 0;
      for (auto individual : individuals)
         out += to_string(++i) + ". " + individual.toString() + "\n";
      return out;
   }

   string computeSelectie()
   {
      computeSum();
      computeProbabilitys();
      computeIntervals();
      return toString();
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

   void crossover(string &out)
   {
      out += "Folosind metoda incrucisarii, obtinem urmatoarea generatie de indivizi\n";

      bool pereche = false;
      Individual *first;
      for (auto &individual : individuals)
      {
         double p = (double)rand() / RAND_MAX;
         if (p > crossover_probability)
            continue;

         if (pereche)
         {
            individual.crossover(*first, out);
            pereche = false;
         }
         else
         {
            first = &individual;
            pereche = true;
         }
      }
      out += "\n";
   }

   // selectie de noi indivizi, prin ruleta, in functie de probabilitatiile calculate deja
   void naturalSelection(string &out)
   {
      out += computeSelectie() + "\n";

      vector<Individual> new_individuals;
      new_individuals.push_back(max_element(individuals.begin(), individuals.end())[0]);

      out += "Folosind metoda ruletei, alegem urmatoarea generatie de indivizi\n";
      out += "1. Il pastram pe cel mai bun: " + new_individuals[0].toString() + "\n";
      out += "Alegem inca " + to_string(size - 1) + " indivizi: \n";

      for (int i = 2; i <= size; i++)
      {
         double p = (double)rand() / RAND_MAX;
         out += to_string(i) + ". Random= " + to_string(p);

         Individual target;
         target.right = p;
         auto it = upper_bound(individuals.begin(), individuals.end(), target,
                               [](const Individual &a, const Individual &b)
                               { return a.right < b.right; });
         new_individuals.push_back(*it);

         out += " -> alegem individul " + to_string(it - individuals.begin() + 1) + ". " + (*it).toString() + "\n";
      }

      out += '\n';

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

   double meanFitness()
   {
      double sum = 0;
      for (auto individual : individuals)
         sum += individual.fitness();
      return sum / individuals.size();
   }

   double maxFitness()
   {
      return max_element(individuals.begin(), individuals.end())[0].fitness();
   }
};
Species Population::species;

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

void solve()
{
   srand(time(NULL));
   ofstream cout("genetic.out");

   Species species(-3, 7, 1); // a, b, c - parametri functiei de species ex; -x^2 + 2x + 1
   species.left = 0;          // capatul din stanga al intervalului de cautare -1
   species.right = 2;         // capatul din dreapta al intervalului de cautare 2
   species.precision = 10;    // 6 - nr de cifre dupa virgula

   Population population;
   population.crossover_probability = 0.25;
   population.mutation_probability = 0.01;
   population.number_of_steps = 200; // 50
   population.size = 20;

   menu(population, species);

   species.intialize();
   Individual::species = species;
   Population::species = species;
   population.randomInit();

   for (int i = 0; i < population.number_of_steps; i++)
   {
      string out = "";
      population.naturalSelection(out);
      population.crossover(out);
      out += "Populația rezultată după recombinare:\n" + population.toString() + "\n";

      population.normalMutation();
      population.rareMutation();
      out += "Populatia rezultata dupa mutatie:\n" + population.toString() + "\n";

      if (!i)
         cout << "Populatie initiala:\n"
              << out;

      cout << setprecision(population.species.precision) << fixed << "Pas " << i + 1 << ": max f(x)=" << population.maxFitness() << ", mean f(x)=" << population.meanFitness() << endl;
   }
}

int main()
{
   try
   {
      solve();
   }
   catch (const string msg)
   {
      cout << "EROARE: " << msg << endl;
   }
}
