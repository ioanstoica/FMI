import java.util.ArrayList;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.time.LocalDateTime;

public class index {
   public static void main(String[] args) {
      // testareClase();

      testareDB();

   }

   static void CRUD_DB(Connection conn) {
      try {
         // Presupunem că conn este deja inițializat și conectat la baza de date
         // Pasul 1: Crearea tabelelor
         Activ.createTable(conn);

         // Aelarea functiior CRUD din clasa Activ:
         Activ.create(conn, "BTC", 25000);
         Activ.create(conn, "ETH", 2000);
         Activ.create(conn, "LTC", 100);

         Activ btc = new Activ("BTC", 25000);
         int id = btc.getId(conn);
         btc = Activ.read(conn, id);
         System.out.println(btc);

         // selectam toate activele din baza de date
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT * FROM activ");
         while (rs.next()) {
            System.out.println(rs.getString("nume") + " " + rs.getDouble("pret"));
         }

         Activ.update(conn, "BTC", 30000);
         btc = Activ.read(conn, 1);
         System.out.println(btc);

         Activ.delete(conn, "BTC");
         btc = Activ.read(conn, 1);
         System.out.println(btc);

         Asset.createTable(conn); // nu e nevoie sa cream tabelele pentru Asset si Crypto, deoarece sunt subclase
         // ale Activ
         // Testare CRUD
         Asset btcAsset = new Asset(btc, 1);
         Asset.create(conn, btcAsset.activ, btcAsset.cantitate);
         Asset btcAsset2 = Asset.read(conn, btcAsset.getId(conn));
         System.out.println(btcAsset2);

         btcAsset2.cantitate = 2;
         Asset.update(conn, 1, btcAsset.activ, btcAsset2.cantitate);
         btcAsset2 = Asset.read(conn, 1);

         Asset.delete(conn, 1);
         btcAsset2 = Asset.read(conn, 1);
         System.out.println(btcAsset2);

         // Clasa FIAT
         Fiat.createTable(conn);

         Fiat.create(conn, "Fiat1", 100.0, "Emitent1");
         Fiat.create(conn, "Fiat2", 200.0, "Emitent2");

         Fiat fiat = new Fiat();
         fiat.nume = "Fiat1";
         id = fiat.getId(conn);

         Fiat fiat1 = Fiat.read(conn, id);
         System.out.println(fiat1);

         Fiat.update(conn, "Fiat1", 150.0, "Emitent3");
         fiat1 = Fiat.read(conn, id);
         System.out.println(fiat1);

         Fiat.delete(conn, "Fiat1");
         fiat1 = Fiat.read(conn, id);
         System.out.println(fiat1);

         // Clasa Exchange
         // Clasa EXCHANGE
         Exchange.createTable(conn);

         Exchange.create(conn, "Exchange1", "Locatie1", "Website1", 1999);
         Exchange.create(conn, "Exchange2", "Locatie2", "Website2", 2000);

         Exchange exchange = new Exchange();
         exchange.nume = "Exchange1";
         id = exchange.getId(conn);

         Exchange exchange1 = Exchange.read(conn, id);
         System.out.println(exchange1);

         Exchange.update(conn, "Exchange1", "Locatie3", "Website3", 2021);
         exchange1 = Exchange.read(conn, id);
         System.out.println(exchange1);

         Exchange.delete(conn, "Exchange1");
         exchange1 = Exchange.read(conn, id);
         System.out.println(exchange1);

         conn.close();

      } catch (SQLException ex) {
         ex.printStackTrace();
      } finally {
         // Închiderea conexiunii
         if (conn != null) {
            try {
               conn.close();
            } catch (SQLException e) {
               e.printStackTrace();
            }
         }
      }
   }

   static void testareDB() {
      Map<String, String> env = new HashMap<>();

      // read file .env
      try {
         FileReader reader = new FileReader(".env");
         BufferedReader bufferedReader = new BufferedReader(reader);

         String line;
         while ((line = bufferedReader.readLine()) != null) {
            String[] parts = line.split("=");
            if (parts.length == 2) {
               String key = parts[0].strip();
               String value = parts[1].strip();
               env.put(key, value);
            } else
               System.out.println("Invalid line in .env file: " + line);
         }
         bufferedReader.close();
      } catch (IOException e) {
         e.printStackTrace();
      }

      String dbURL = env.get("DB_URL");
      String username = env.get("DB_USER");
      String password = env.get("DB_PASS");

      Connection conn = null;
      try {
         // Pasul 1: Încarcăm driverul JDBC.
         Class.forName("oracle.jdbc.OracleDriver");

         // Pasul 2: Deschide o conexiune
         conn = DriverManager.getConnection(dbURL, username, password);

         if (conn != null) {
            System.out.println("Conectat cu succes la baza de date Oracle!");

            CRUD_DB(conn);
         }
      } catch (SQLException ex) {
         ex.printStackTrace();
      } catch (ClassNotFoundException ex) {
         ex.printStackTrace();
      } finally {
         // Pasul 3: Închide conexiunea pentru a elibera resursele
         if (conn != null) {
            try {
               conn.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
         }
      }
   }

   static void testareClase() {
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

class AuditService {
   private static AuditService auditServiceInstance = null;
   private static final String AUDIT_FILE = "audit.csv";

   private AuditService() {
   }

   public static AuditService getInstance() {
      if (auditServiceInstance == null) {
         auditServiceInstance = new AuditService();
      }
      return auditServiceInstance;
   }

   public void logAction(String actionName) {
      try (PrintWriter writer = new PrintWriter(new FileWriter(AUDIT_FILE, true))) {
         writer.println(LocalDateTime.now() + ", " + actionName);
      } catch (IOException e) {
         System.out.println("Error writing to audit file.");
         e.printStackTrace();
      }
   }
}

class Cont {
   ArrayList<Asset> active = new ArrayList<Asset>();
   IstoricTranzactii istoric = new IstoricTranzactii();

   void addAsset(Asset asset) {
      for (Asset a : active) {
         if (a.activ.nume.equals(asset.activ.nume)) {
            if (a.cantitate + asset.cantitate < 0)
               throw new IllegalArgumentException(
                     "Asset-ul " + asset + " nu poate fi adaugat in cont, in cantitate negativa");
            a.cantitate += asset.cantitate;
            return;
         }
      }
      if (asset.cantitate < 0)
         throw new IllegalArgumentException(
               "Asset-ul " + asset + " nu poate fi adaugat in cont, in cantitate negativa");
      active.add(asset);
   }

   void removeAsset(Asset asset) {
      active.remove(asset);
   }

   void removeAsset(int index) {
      active.remove(index);
   }

   public String toString() {
      return "Cont: {" + active + "}";
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
      Activ first = tranzactie.pereche.first;
      Activ second = tranzactie.pereche.second;
      if (!enough(new Asset(first, tranzactie.valoare)))
         throw new IllegalArgumentException("Asset-ul " + first + " nu exista in cont, in cantitate suficienta");

      istoric.addTranzactie(tranzactie);
      this.addAsset(new Asset(first, -tranzactie.valoare));
      this.addAsset(new Asset(second, tranzactie.valoare * tranzactie.pereche.raport));
   }
}

class Client {
   private String nume = "";
   ArrayList<Cont> conturi = new ArrayList<Cont>();

   public String getNume() {
      return nume;
   }

   public void setNume(String nume) {
      this.nume = nume;
   }

   Client() {
   }

   Client(String nume) {
      this.nume = nume;
   }

   public String toString() {
      return "Client: {nume: " + nume + ", conturi: " + conturi + "}";
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

   int getId(Connection conn) throws SQLException {
      String sql = "SELECT id FROM activ WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
         return rs.getInt("id");
      } else {
         return -1;
      }
   }

   public String toString() {
      return "Activ: {nume: " + nume + ", pret: " + pret + "}";
   }

   public static void createTable(Connection conn) throws SQLException {
      ResultSet tables = conn.getMetaData().getTables(null, null, "ACTIV", null);
      if (tables.next())
         return;

      String sql = "CREATE TABLE activ (" +
            "id SERIAL PRIMARY KEY, " +
            "nume VARCHAR(255) NOT NULL, " +
            "pret DOUBLE PRECISION" +
            ");";

      Statement stmt = conn.createStatement();
      stmt.execute(sql);

      AuditService.getInstance().logAction("Activ table created");
   }

   // CREATE
   public static void create(Connection conn, String nume, double pret) throws SQLException {
      String sql = "INSERT INTO activ(nume, pret) VALUES(?, ?)";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      stmt.setDouble(2, pret);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Activ created:" + nume + "," + pret);
   }

   // READ
   public static Activ read(Connection conn, int id) throws SQLException {
      String sql = "SELECT * FROM activ WHERE ID = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
         AuditService.getInstance().logAction("Activ read: " + id);
         return new Activ(rs.getString("nume"), rs.getDouble("pret"));
      }
      return null;
   }

   // UPDATE
   public static void update(Connection conn, String nume, double pret) throws SQLException {
      String sql = "UPDATE activ SET pret = ? WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setDouble(1, pret);
      stmt.setString(2, nume);
      stmt.executeUpdate();
      AuditService.getInstance().logAction("Activ updated: " + nume + "," + pret);
   }

   // DELETE
   public static void delete(Connection conn, String nume) throws SQLException {
      String sql = "DELETE FROM activ WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Activ deleted: " + nume);
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
      return "Asset: {" + activ + ", cantitate: " + cantitate + "}";
   }

   int getId(Connection conn) {
      try {
         String sql = "SELECT id FROM asset WHERE activ_id = ? AND cantitate = ?";
         PreparedStatement stmt = conn.prepareStatement(sql);
         stmt.setInt(1, activ.getId(conn));
         stmt.setDouble(2, cantitate);
         ResultSet rs = stmt.executeQuery();

         if (rs.next()) {
            return rs.getInt("id");
         } else {
            return -1;
         }
      } catch (SQLException e) {
         e.printStackTrace();
         return -1;
      }
   }

   double valoare() {
      return cantitate * activ.pret;
   }

   public static void createTable(Connection conn) throws SQLException {
      ResultSet tables = conn.getMetaData().getTables(null, null, "ASSET", null);
      if (tables.next())
         return;

      // Crearea secvenței
      String createSequence = "CREATE SEQUENCE asset_seq START WITH 1 INCREMENT BY 1 NOCACHE";
      Statement seqStmt = conn.createStatement();
      seqStmt.execute(createSequence);

      // Crearea tabelei
      String createTable = "CREATE TABLE asset (" +
            "id NUMBER PRIMARY KEY, " +
            "activ_id NUMBER NOT NULL, " +
            "cantitate NUMBER, " +
            "FOREIGN KEY (activ_id) REFERENCES activ(id)" +
            ")";
      Statement tableStmt = conn.createStatement();
      tableStmt.execute(createTable);

      // Crearea trigger-ului
      String createTrigger = "CREATE OR REPLACE TRIGGER asset_trigger " +
            "BEFORE INSERT ON asset " +
            "FOR EACH ROW " +
            "BEGIN " +
            "SELECT asset_seq.NEXTVAL INTO :new.id FROM dual; " +
            "END;";
      Statement triggerStmt = conn.createStatement();
      triggerStmt.execute(createTrigger);

      seqStmt.close();
      tableStmt.close();
      triggerStmt.close();

      AuditService.getInstance().logAction("Asset table created");
   }

   // CREATE
   public static void create(Connection conn, Activ activ, double cantitate) throws SQLException {
      String sql = "INSERT INTO asset(activ_id, cantitate) VALUES(?, ?)";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, activ.getId(conn));
      stmt.setDouble(2, cantitate);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Asset created: " + activ + "," + cantitate + "");
   }

   // READ
   public static Asset read(Connection conn, int id) throws SQLException {
      String sql = "SELECT * FROM asset WHERE id = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
         Activ activ = Activ.read(conn, rs.getInt("activ_id"));
         AuditService.getInstance().logAction("Asset read: " + id + " " + activ + " " + rs.getDouble("cantitate") + "");
         return new Asset(activ, rs.getDouble("cantitate"));
      } else {
         return null;
      }
   }

   // UPDATE
   public static void update(Connection conn, int id, Activ activ, double cantitate) throws SQLException {
      String sql = "UPDATE asset SET activ_id = ?, cantitate = ? WHERE id = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, activ.getId(conn));
      stmt.setDouble(2, cantitate);
      stmt.setInt(3, id);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Asset updated: " + id + " " + activ + " " + cantitate + "");
   }

   // DELETE
   public static void delete(Connection conn, int id) throws SQLException {
      String sql = "DELETE FROM asset WHERE id = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Asset deleted: " + id + "");
   }
}

class Crypto extends Asset {
   // block chain
   String blockchain;

   Crypto(Activ activ, double cantitate) {
      super(activ, cantitate);
   }

   Crypto() {
   }

   public String toString() {
      return "Crypto: {" + activ + ", cantitate: " + cantitate + "}";
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
      return "Pereche: {first: " + first + ", second: " + second + ", raport: " + raport + "}";
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
      return "Tranzactie: {pereche: " + pereche + ", valoare: " + valoare + "}";
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
      return "IstoricTranzactii: {" + tranzactii + "}";
   }
}

class Fiat {
   String nume;
   double pret; // pret in USD
   String emitent;

   Fiat(String nume, double pret, String emitent) {
      this.nume = nume;
      this.pret = pret;
      this.emitent = emitent;
   }

   Fiat() {
   }

   int getId(Connection conn) throws SQLException {
      String sql = "SELECT id FROM fiat WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
         return rs.getInt("id");
      } else {
         return -1;
      }
   }

   public String toString() {
      return "Fiat: {nume: " + nume + ", pret: " + pret + ", emitent: " + emitent + "}";
   }

   public static void createTable(Connection conn) throws SQLException {
      ResultSet tables = conn.getMetaData().getTables(null, null, "FIAT", null);

      if (!tables.next()) {
         // Create table
         String sql = "CREATE TABLE fiat (" +
               "id NUMBER PRIMARY KEY, " +
               "nume VARCHAR2(255) NOT NULL, " +
               "pret NUMBER(10,2), " +
               "emitent VARCHAR2(255)" +
               ")";
         Statement stmt = conn.createStatement();
         stmt.execute(sql);

         // Create sequence
         sql = "CREATE SEQUENCE fiat_seq START WITH 1";
         stmt = conn.createStatement();
         stmt.execute(sql);

         // Create trigger for auto increment
         sql = "CREATE OR REPLACE TRIGGER fiat_trigger " +
               "BEFORE INSERT ON fiat " +
               "FOR EACH ROW " +
               "BEGIN " +
               "SELECT fiat_seq.NEXTVAL " +
               "INTO :new.id " +
               "FROM dual; " +
               "END;";
         stmt = conn.createStatement();
         stmt.execute(sql);

         AuditService.getInstance().logAction("Fiat table created");
      }
   }

   // CREATE
   public static void create(Connection conn, String nume, double pret, String emitent) throws SQLException {
      String sql = "INSERT INTO fiat(nume, pret, emitent) VALUES(?, ?, ?)";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      stmt.setDouble(2, pret);
      stmt.setString(3, emitent);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Fiat created: " + nume + "," + pret + "," + emitent + "");
   }

   // READ
   public static Fiat read(Connection conn, int id) throws SQLException {
      String sql = "SELECT * FROM fiat WHERE ID = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
         AuditService.getInstance().logAction("Fiat read: " + id + "");
         return new Fiat(rs.getString("nume"), rs.getDouble("pret"), rs.getString("emitent"));
      } else {
         return null;
      }
   }

   // UPDATE
   public static void update(Connection conn, String nume, double pret, String emitent) throws SQLException {
      String sql = "UPDATE fiat SET pret = ?, emitent = ? WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setDouble(1, pret);
      stmt.setString(2, emitent);
      stmt.setString(3, nume);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Fiat updated: " + nume + "," + pret + "," + emitent + "");
   }

   // DELETE
   public static void delete(Connection conn, String nume) throws SQLException {
      String sql = "DELETE FROM fiat WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Fiat deleted: " + nume + "");
   }
}

class Exchange {
   String nume;
   String locatie;
   String website;
   int an_infiintare;

   Exchange(String nume, String locatie, String website, int an_infiintare) {
      this.nume = nume;
      this.locatie = locatie;
      this.website = website;
      this.an_infiintare = an_infiintare;
   }

   Exchange() {
   }

   int getId(Connection conn) throws SQLException {
      String sql = "SELECT id FROM exchange WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
         AuditService.getInstance().logAction("Exchange read: " + nume + "");
         return rs.getInt("id");
      } else {
         return -1;
      }
   }

   public String toString() {
      return "Exchange: {nume: " + nume + ", locatie: " + locatie + ", website: " + website + ", an_infiintare: "
            + an_infiintare + "}";
   }

   public static void createTable(Connection conn) throws SQLException {
      ResultSet tables = conn.getMetaData().getTables(null, null, "EXCHANGE", null);
      if (!tables.next()) {
         String sql = "CREATE TABLE exchange (" +
               "id NUMBER PRIMARY KEY, " +
               "nume VARCHAR2(255) NOT NULL, " +
               "locatie VARCHAR2(255), " +
               "website VARCHAR2(255), " +
               "an_infiintare NUMBER" +
               ")";
         Statement stmt = conn.createStatement();
         stmt.execute(sql);

         sql = "CREATE SEQUENCE exchange_seq START WITH 1";
         stmt = conn.createStatement();
         stmt.execute(sql);

         sql = "CREATE OR REPLACE TRIGGER exchange_trigger " +
               "BEFORE INSERT ON exchange " +
               "FOR EACH ROW " +
               "BEGIN " +
               "SELECT exchange_seq.NEXTVAL " +
               "INTO :new.id " +
               "FROM dual; " +
               "END;";
         stmt = conn.createStatement();
         stmt.execute(sql);

         AuditService.getInstance().logAction("Exchange table created");

      }
   }

   // CREATE
   public static void create(Connection conn, String nume, String locatie, String website, int an_infiintare)
         throws SQLException {
      String sql = "INSERT INTO exchange(id, nume, locatie, website, an_infiintare) VALUES(exchange_seq.NEXTVAL, ?, ?, ?, ?)";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      stmt.setString(2, locatie);
      stmt.setString(3, website);
      stmt.setInt(4, an_infiintare);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Exchange created: " + nume + "," + locatie + "," + website + ","
            + an_infiintare + "");
   }

   // READ
   public static Exchange read(Connection conn, int id) throws SQLException {
      String sql = "SELECT * FROM exchange WHERE ID = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
         AuditService.getInstance().logAction("Exchange read: " + id + "");
         return new Exchange(rs.getString("nume"), rs.getString("locatie"), rs.getString("website"),
               rs.getInt("an_infiintare"));
      } else {
         return null;
      }
   }

   // UPDATE
   public static void update(Connection conn, String nume, String locatie, String website, int an_infiintare)
         throws SQLException {
      String sql = "UPDATE exchange SET locatie = ?, website = ?, an_infiintare = ? WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, locatie);
      stmt.setString(2, website);
      stmt.setInt(3, an_infiintare);
      stmt.setString(4, nume);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Exchange updated: " + nume + "," + locatie + "," + website + ","
            + an_infiintare + "");
   }

   // DELETE
   public static void delete(Connection conn, String nume) throws SQLException {
      String sql = "DELETE FROM exchange WHERE nume = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, nume);
      stmt.executeUpdate();

      AuditService.getInstance().logAction("Exchange deleted: " + nume + "");
   }
}
