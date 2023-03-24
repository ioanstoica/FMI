class masina implements Comparable<masina> {
   public String marca;
   public int an;
   public int pret;
   public int emisii;

   public int compareTo(masina m) {
      // compare by alfabetical by marca, then descending by an, then ascending by
      // pret, then descending by emisii
      if (marca.compareTo(m.marca) != 0) {
         return marca.compareTo(m.marca);
      } else if (an != m.an) {
         return m.an - an;
      } else if (pret != m.pret) {
         return pret - m.pret;
      } else {
         return m.emisii - emisii;
      }
   }
}

public class comparare {
   public static void main(String args[]) {
      System.out.println("Hello World!");

      // declare an array of masina
      masina[] masini = new masina[3];
      // fill masini with datas
      masini[0] = new masina();
      masini[0].marca = "Audi";
      masini[0].an = 2010;
      masini[0].pret = 10000;
      masini[0].emisii = 100;

      masini[1] = new masina();
      masini[1].marca = "BMW";
      masini[1].an = 2011;
      masini[1].pret = 20000;
      masini[1].emisii = 200;

      masini[2] = new masina();
      masini[2].marca = "Mercedes";
      masini[2].an = 2012;
      masini[2].pret = 30000;
      masini[2].emisii = 300;

      // sort masini using Arrays.sort
      java.util.Arrays.sort(masini);

      // print masini
      for (int i = 0; i < masini.length; i++) {
         System.out.println(masini[i].marca + " " + masini[i].an + " "
               + masini[i].pret + " " + masini[i].emisii);
      }
   };
}
