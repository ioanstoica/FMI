public class ex5 {
   // print "Hello world"
   public static void main(String[] args) {
      System.out.println("Hello world");
      // DirectorGeneral directorGeneral = new DirectorGeneral();

      // new Casier
      Casier casier = new Casier("Alin", "Matei", "Je", "Casier");
      System.out.println(casier);
   }
}

record Casier(String nume, String prenume, String marca, String functie) implements Cloneable {
   public Casier(String nume, String prenume, String marca, String functie) {
      this.nume = nume;
      this.prenume = prenume;
      this.marca = marca;
      this.functie = functie;
   }

   @Override
   public Object clone() throws CloneNotSupportedException {
      return super.clone();
   }

   @Override
   public String toString() {
      return "Casier{" +
            "nume='" + nume + '\'' +
            ", prenume='" + prenume + '\'' +
            ", marca='" + marca + '\'' +
            ", functie='" + functie + '\'' +
            '}';
   }
}

final class Secretar extends Angajat {
}

final class DirectorGeneral extends Angajat implements Director {
}

sealed class Angajat implements Cloneable permits Secretar, DirectorGeneral {
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
   public Object clone() throws CloneNotSupportedException {
      return super.clone();
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

sealed interface Director permits DirectorEchipa, Programator, DirectorGeneral {
}

non-sealed interface Programator extends Director {
}

non-sealed interface DirectorEchipa extends Director {
}

interface Manager extends DirectorEchipa {
}
