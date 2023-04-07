import java.util.ArrayList;

class Cont {
   ArrayList<Asset> active = new ArrayList<Asset>();

   void addAsset(Asset asset) {
      active.add(asset);
   }
}

class Client {
   String nume = "";
   Cont cont = new Cont();

   Client() {
   }

   Client(String nume) {
      this.nume = nume;
   }

   public String toString() {
      return "Client: " + nume;
   }

}

class Activ {
   String nume;
   double valoare;

   Activ(String nume, double valoare) {
      this.nume = nume;
      this.valoare = valoare;
   }

   Activ() {
   }

   public String toString() {
      return "Activ: " + nume + " " + valoare;
   }

}

class Asset {
   Activ activ;
   double cantitate;

   Asset(Activ activ, double cantitate) {
      this.activ = activ;
      this.cantitate = cantitate;
   }

   Asset() {
   }

   public String toString() {
      return "Asset: " + activ + " " + cantitate;
   }
}

class Pereche {
   Activ first, second;
   double raport; // first / second
}

class Tranzactie {
   Pereche pereche;
   double valoare;
}

class IstoricTranzactii {
   Tranzactie[] tranzactii;
}

class Main {
   public static void main(String[] args) {
      // print("Hello, World!")
      System.out.println("Hello, World!");

      Client Client = new Client("Stoica");
      // Cont[] conturi = new Cont[10];
      // IstoricTranzactii[] istoric = new IstoricTranzactii[10];
      // ...

      System.out.println(Client);

      Client.cont.addAsset(new Asset(new Activ("USD", 1000), 1));
      // Client.cont.addActiv(new Activ("EUR", 2000));
      // Client.cont.addActiv(new Activ("RON", 3000));

      System.out.println(Client.cont.active);
   }
}