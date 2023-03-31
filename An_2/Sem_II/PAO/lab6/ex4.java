public class ex4 {
   // print "Hello world"
   public static void main(String[] args) {
      System.out.println("Hello world");
      // firma firma1 = new firma();
      Firma.Manager manager = new Firma.Manager("Popescu", "Ion", "123", "programator");
      // new Secretar
      System.out.println(manager);

   }
}

class Firma {

   abstract static class Angajat {
      String nume;
      String prenume;
      String marca;
      String functie;

      // constructorul implicit
      public Angajat() {
      }

      public Angajat(String nume, String prenume, String marca, String functie) {
         this.nume = nume;
         this.prenume = prenume;
         this.marca = marca;
         this.functie = functie;
      }

      @Override
      public String toString() {
         return "Angajat{" +
               "nume='" + nume + '\'' +
               ", prenume='" + prenume + '\'' +
               ", marca='" + marca + '\'' +
               ", functie='" + functie + '\'' +
               '}';
      }
   }

   public static class Secretar extends Angajat {
      // constructorul implicit
      public Secretar() {
      }

      public Secretar(String nume, String prenume, String marca, String functie) {
         super(nume, prenume, marca, functie);
      }

      @Override
      public String toString() {
         return "Secretar{" +
               "nume='" + nume + '\'' +
               ", prenume='" + prenume + '\'' +
               ", marca='" + marca + '\'' +
               ", functie='" + functie + '\'' +
               '}';
      }
   }

   public static class Manager extends Angajat {
      // constructorul implicit
      public Manager() {
      }

      public Manager(String nume, String prenume, String marca, String functie) {
         this.nume = nume;
         this.prenume = prenume;
         this.marca = marca;
         this.functie = functie;
      }

      @Override
      public String toString() {
         return "Manager{" +
               "nume='" + nume + '\'' +
               ", prenume='" + prenume + '\'' +
               ", marca='" + marca + '\'' +
               ", functie='" + functie + '\'' +
               '}';
      }
   }
}