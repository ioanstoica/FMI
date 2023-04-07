import java.util.ArrayList;

class Cont {
   ArrayList<Asset> active = new ArrayList<Asset>();
   IstoricTranzactii istoric = new IstoricTranzactii();

   void addAsset(Asset asset) {
      if (asset.cantitate <= 0)
         throw new IllegalArgumentException("Cantitatea nu poate fi negativa sau nula");

      // daca activul exista deja, actualizam cantitatea
      for (Asset a : active) {
         if (a.activ.nume.equals(asset.activ.nume)) {
            a.cantitate += asset.cantitate;
            return;
         }
      }

      active.add(asset);
   }

   void removeAsset(Asset asset) {
      active.remove(asset);
   }

   void removeAsset(int index) {
      active.remove(index);
   }

   public String toString() {
      return "Cont: " + active;
   }

   double valoare() {
      double valoare = 0;
      for (Asset asset : active) {
         valoare += asset.valoare();
      }
      return valoare;
   }

   boolean enough(Asset asset) {
      for (Asset a : active)
         if (a.activ.nume.equals(asset.activ.nume) && a.cantitate >= asset.cantitate)
            return true;
      return false;
   }

   void addTranzactie(Tranzactie tranzactie) {
      // verificare daca tranzactia este valida
      // daca unul dintre activele tranzacitiei nu exista in cont, aruncam exceptie
      // daca valoarea tranzactiei este mai mare decat valoarea contului, aruncam
      // exceptie
      // daca valoarea tranzactiei este mai mica decat valoarea contului, adaugam
      // tranzactia
      // si actualizam activele contului

      if (tranzactie.pereche == null || tranzactie.pereche.first == null || tranzactie.pereche.second == null)
         throw new IllegalArgumentException("Perechea nu este definita complet");

      Activ first = tranzactie.pereche.first;
      if (!enough(new Asset(first, tranzactie.valoare)))
         throw new IllegalArgumentException("Asset-ul " + first + " nu exista in cont, in cantitate suficienta");

      istoric.addTranzactie(tranzactie);

      // actualizare active
      for (Asset asset : active) {
         if (asset.activ.nume.equals(first.nume)) {
            asset.cantitate -= tranzactie.valoare;
         } else if (asset.activ.nume.equals(tranzactie.pereche.second.nume)) {
            asset.cantitate += tranzactie.valoare * tranzactie.pereche.raport;
         }
      }
   }
}

class Client {
   String nume = "";
   ArrayList<Cont> conturi = new ArrayList<Cont>();

   Client() {
   }

   Client(String nume) {
      this.nume = nume;
   }

   public String toString() {
      return "Client: " + nume + "\n" + conturi;
   }

   void addCont(Cont cont) {
      this.conturi.add(cont);
   }

   double valoare() {
      double valoare = 0;
      for (Cont cont : conturi) {
         valoare += cont.valoare();
      }
      return valoare;
   }

}

class Activ {
   String nume;
   double pret; // pret in USD

   Activ(String nume, double pret) {
      this.nume = nume;
      this.pret = pret;
   }

   Activ() {
   }

   public String toString() {
      return "Activ: " + nume + " " + pret;
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
      return "Asset: " + cantitate + " " + activ;
   }

   double valoare() {
      return cantitate * activ.pret;
   }
}

class Pereche {
   Activ first, second;
   double raport; // first / second

   Pereche(Activ first, Activ second) {
      this.first = first;
      this.second = second;
      this.raport = first.pret / second.pret;
   }

   Pereche() {
   }

   public String toString() {
      return "Pereche: (" + first + ", " + second + ") raport: " + raport;
   }
}

class Tranzactie {
   Pereche pereche;
   double valoare;

   Tranzactie(Pereche pereche, double valoare) {
      this.pereche = pereche;
      this.valoare = valoare;
   }

   Tranzactie() {
   }

   public String toString() {
      return "Tranzactie: " + pereche + " valoare: " + valoare;
   }
}

class IstoricTranzactii {
   ArrayList<Tranzactie> tranzactii = new ArrayList<Tranzactie>();

   void addTranzactie(Tranzactie tranzactie) {
      tranzactii.add(tranzactie);
   }

   void removeTranzactie(Tranzactie tranzactie) {
      tranzactii.remove(tranzactie);
   }

   void removeTranzactie(int index) {
      tranzactii.remove(index);
   }

   public String toString() {
      return "IstoricTranzactii: " + tranzactii;
   }
}

class Main {
   public static void main(String[] args) {
      Client client = new Client("Stoica");
      client.addCont(new Cont());
      client.addCont(new Cont());

      Cont cont0 = client.conturi.get(0);

      Activ activ0 = new Activ("USD", 1);
      Activ activ1 = new Activ("EUR", 1);
      Activ activ2 = new Activ("RON", 0.2);

      cont0.addAsset(new Asset(activ0, 1000));
      cont0.addAsset(new Asset(activ1, 1000));
      cont0.addAsset(new Asset(activ2, 6000));

      System.out.println(client);

      Asset asset = cont0.active.get(0);
      System.out.println(asset);
      System.out.println(asset.valoare());
      System.out.println(cont0.valoare());

      Cont cont1 = client.conturi.get(1);
      cont1.addAsset(asset);

      System.out.println(client);
      System.out.println(client.valoare());

      Pereche pereche = new Pereche(activ0, activ1);
      System.out.println(pereche.raport);
      Tranzactie tranzactie = new Tranzactie(pereche, 500);
      System.out.println(tranzactie);
      System.out.println(cont0);
      try {
         cont0.addTranzactie(tranzactie);
      } catch (Exception e) {
         System.out.println(e);
      }

      System.out.println(cont0);

      cont0.addAsset(asset);
      System.out.println(cont0);

      cont0.addTranzactie(new Tranzactie(new Pereche(activ0, activ2), 100));
      System.out.println(cont0);

   }
}