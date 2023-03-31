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



// print "Hello world"
public class Test {
   public static void main(String[] args) throws CloneNotSupportedException {
      System.out.println("Hello world");
      Angajat angajat1 = new Angajat("Popescu", "Ion", "123", "programator");
      Angajat angajat2 = (Angajat) angajat1.clone();
      angajat2.nume = "Ionescu";

      System.out.println(angajat1);
      System.out.println(angajat2);
   }
}