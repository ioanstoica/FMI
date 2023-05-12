#include <bits/stdc++.h>

using namespace std;

class Cromozom
{
public:
   string gena;
};

void incrucisare(Cromozom &x, Cromozom &y, int p)
{
   string x_aux = x.gena.substr(0, p) + y.gena.substr(p);
   string y_aux = y.gena.substr(0, p) + x.gena.substr(p);
   x.gena = x_aux;
   y.gena = y_aux;
}

double fitness(double x, double a, double b, double c)
{
   return a * x * x + b * x + c;
}

string TO(double x, double a, double d, int l)
{
   string s;
   int n = (x - a) / d;
   for (int i = 0; i < l; i++)
   {
      s += (n % 2) + '0';
      n /= 2;
   }
   reverse(s.begin(), s.end());
   return s;
}

double FROM(string s, double a, double d, int l)
{
   int n = 0;
   for (int i = 0; i < l; i++)
      n = n * 2 + (s[i] - '0');
   return a + n * d;
}

int main()
{
   ofstream cout("genetic.out");

   /*
   Date de intrare
   • Dimensiunea populației (numărul de cromozomi)
   • Domeniul de definiție al funcției (capetele unui interval închis)
   • Parametrii pentru funcția de maximizat (coeficienții polinomului
   de grad 2)
   • Precizia cu care se lucrează (cu care se discretizează intervalul)
   • Probabilitatea de recombinare (crossover, încrucișare)
   • Probabilitatea de mutație
   • Numărul de etape al algoritmului
   */

   int population_size = 20;
   double domain_start_a = -1, domain_end_b = 2;
   double a = -1, b = 1, c = 2;
   double precision = 6; // 6
   double crossover_probability = 0.25;
   double mutation_probability = 0.01;
   int number_of_steps = 50; // 50

   // l = ceil(log2((b - a) * pow(10, p))); // numarul de biti necesari pentru a codifica un numar
   double l = ceil(log2((domain_end_b - domain_start_a) * pow(10, precision)));
   // d = (b - a) / pow(2, l);              // pasul de discretizare
   double d = (domain_end_b - domain_start_a) / pow(2, l);

   // 1. Initializeaza populatia
   vector<double> population;
   srand(time(NULL));
   for (int i = 0; i < population_size; i++)
   {
      double random = (double)rand() / RAND_MAX;
      double value = domain_start_a + random * (domain_end_b - domain_start_a);
      population.push_back(value);
   }

   // print population
   cout << "1. Initial population: " << endl;
   for (int i = 0; i < population.size(); i++)
   {
      cout << population[i] << " ";
   }

   // 2. Reprezinta fiecare individ din populatie ca un cromozom
   // 3. Calculeaza fitness-ul pentru fiecare cromozom
   vector<double> fitness_values;
   for (int i = 0; i < population.size(); i++)
   {
      double value = fitness(population[i], a, b, c);
      fitness_values.push_back(value);
   }

   // print fitness values
   cout << endl
        << "2. Fitness values: " << endl;
   for (int i = 0; i < fitness_values.size(); i++)
   {
      cout << fitness_values[i] << " ";
   }
   cout << endl;

   for (int i = 0; i < number_of_steps; i++)
   {
      cout << "Step " << i << ": " << endl;

      // 4. Selecteaza cei mai buni indivizi
      // sort population by fitness
      for (int i = 0; i < population.size(); i++)
      {
         for (int j = i + 1; j < population.size(); j++)
         {
            if (fitness_values[i] < fitness_values[j])
            {
               swap(fitness_values[i], fitness_values[j]);
               swap(population[i], population[j]);
            }
         }
      }

      // print population
      cout << "3. Sorted population: " << endl;
      for (int i = 0; i < population.size(); i++)
      {
         cout << fitness_values[i] << " - " << population[i] << " " << endl;
      }

      // *  criteriul elitist: elementul (sau elementele, dupa caz) cel mai bun va trece direct (si nemodificat) in generatia urmatoare. Garantează ca individul cel mai bun de la o anumita generatie este mai bun de cat oricare element din oricare generatie precedenta.
      vector<double> new_population;
      new_population.push_back(population[0]);

      vector<double> new_fitness_values;
      new_fitness_values.push_back(fitness_values[0]);

      // * raman n-1 locuri disponibile.
      // * selectam n-1 indivizi din generatia curenta, folosind metoda ruletei

      // Calculăm suma fitness-urilor (sf) pentru toți indivizii din populație
      double sum_fitness = 0;
      for (int i = 0; i < fitness_values.size(); i++)
      {
         sum_fitness += fitness_values[i];
      }

      // Calculăm probabilitatea de selecție (ps) pentru fiecare individ
      vector<double> selection_probability;
      for (int i = 0; i < fitness_values.size(); i++)
      {
         double value = fitness_values[i] / sum_fitness;
         selection_probability.push_back(value);
      }

      // calculam intervalele de selecție (is) pentru fiecare individ
      vector<double> selection_intervals;
      double sum = 0;
      for (int i = 0; i < selection_probability.size(); i++)
      {
         sum += selection_probability[i];
         selection_intervals.push_back(sum);
      }

      // selectam n-1 indivizi din generatia curenta, folosind metoda ruletei
      for (int i = 0; i < population.size() - 1; i++)
      {
         double random = (double)rand() / RAND_MAX;
         for (int j = 0; j < selection_intervals.size(); j++)
         {
            if (random < selection_intervals[j])
            {
               new_population.push_back(population[j]);
               new_fitness_values.push_back(fitness_values[j]);
               break;
            }
         }
      }

      // print new population
      cout << "4. New population: " << endl; // populatia intermediara
      for (int i = 0; i < new_population.size(); i++)
      {
         cout << new_fitness_values[i] << " - " << new_population[i] << " " << endl;
      }

      // Pe aceasta populatie intermediara aplicam operatorul genetic de crossing over (încrucișare)​
      // Avem o probabilitate de crossing over (data ca parametru de intrare) ex: crossover_probability=0.25
      // Pentru fiecare individ din populatie, generam un numar aleator (random) între 0 si 1. Daca acest numar este mai mic decat probabilitatea de crossing over, atunci individul respectiv va fi supus încrucișarii.
      // În cazul în care individul este supus încrucișarii, se alege aleator un alt individ din populatie si se realizeaza încrucișarea între cei doi indivizi.
      // Încrucișarea se realizeaza prin interschimbarea unui numar aleator de gene între cei doi indivizi.
      // În urma încrucișarii se obtin doi indivizi noi, care vor fi introdusi în populatia intermediara.
      // Daca individul nu este supus încrucișarii, atunci acesta va fi introdus în populatia intermediara nemodificat.

      vector<double> crossover_population;
      vector<int> crossover_used;

      for (int i = 0; i < new_population.size(); i++)
      {
         double random = (double)rand() / RAND_MAX;
         if (random < crossover_probability)
         {
            crossover_population.push_back(new_population[i]);
            crossover_used.push_back(i);
         }
      }

      // print crossover population
      cout << "5. Crossover population: " << endl;
      for (int i = 0; i < crossover_population.size(); i++)
      {
         cout << crossover_used[i] << " " << crossover_population[i] << " ";
      }
      cout << endl;

      // Odata ce avem multimea de indivizi selectati pt incrucisare, eventual dam un shuffle si ii luam perechi de 2 cate 2 (eventual in caz de numar impar ii luam pe ultimii 3 la un loc)
      // si facem incrucisarea intre ei.
      // Dupa ce am facut incrucisarea, adaugam indivizii rezultati in populatia intermediara.
      // Daca numarul de indivizi selectati pt incrucisare este impar, atunci ultimul individ va fi adaugat nemodificat in populatia intermediara.

      // 5. Reproducerea prin incrucisare
      for (int j = 0; j < crossover_population.size() - 1; j += 2)
      {
         // crossover intre j si j+1
         string s1 = TO(crossover_population[j], domain_start_a, d, l);
         string s2 = TO(crossover_population[j + 1], domain_start_a, d, l);
         // print
         cout << "6. Crossover between " << crossover_population[j] << " and " << crossover_population[j + 1] << endl;
         cout << "   " << s1 << endl;
         cout << "   " << s2 << endl;

         // crossover
         Cromozom c1;
         c1.gena = s1;
         Cromozom c2;
         c2.gena = s2;

         int size = c1.gena.size();
         int random = rand() % size;

         incrucisare(c1, c2, random);
         // Aceste 2 elemente se vor alătura celor care nu au fost selectate pentru încrucișare​

         double x1 = FROM(c1.gena, domain_start_a, d, l);
         double x2 = FROM(c2.gena, domain_start_a, d, l);

         // move new elements to his position
         new_population[crossover_used[j]] = x1;
         new_population[crossover_used[j + 1]] = x2;
      }
      // print new population
      cout << "7. New population: " << endl; // populatia intermediara
      for (int i = 0; i < new_population.size(); i++)
      {
         cout << new_fitness_values[i] << " - " << new_population[i] << " " << endl;
      }

      // 6. Mutatie
      // 7. Repetarea
      // populatia intermediara devine populatia curenta
      population = new_population;
      fitness_values = new_fitness_values;
   }
}