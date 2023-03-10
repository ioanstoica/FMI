import java.util.Scanner;
import java.io.File;

public class animale {
    public static void main(String args[]) throws Exception {
        File myFile = new File("animale.in");
        Scanner in = new Scanner(myFile);
        // citim numarul de tratamente
        int n = in.nextInt();
        // cream un vector de tratamente
        tratament[] tratamente = new tratament[n];
        // citim tratamentele
        for (int i = 0; i < n; i++) {
            tratamente[i] = new tratament(in);
        }
        in.close();

        // cream un vector de animale
        animal[] animale = new animal[3];
        animale[0] = new caine(tratamente);// cream un caine
        animale[1] = new pisica(tratamente);// cream o pisica
        animale[2] = new papagal(tratamente);// cream un papagal

        animale[0].tratamente[0].descriere = "Hymatil";// modificam pretul tratamentului

        // afisam animalele
        for (int i = 0; i < 3; i++) {
            System.out.println(animale[i]);
        }
    }
}

// clasa tratament, cu campurile descriere si pret
class tratament {
    String descriere;
    int pret;

    // constructorul clasei tratament
    tratament() {
    }

    // constructorul de copiere al clasei tratament
    tratament(tratament t) {
        this.descriere = t.descriere;
        this.pret = t.pret;
    }

    // constructorul clasei tratament cu parametrul Scanner in
    tratament(Scanner in) {
        descriere = in.next();
        pret = in.nextInt();
    }

    // suprascrierea metodei toString
    public String toString() {
        return "Tratamentul " + descriere + " costa " + pret;
    }

}

// clasa abstracta animal, cu campurile tip, lista tratamente, si o metoda
// abstracta factura
abstract class animal {
    String tip;
    tratament[] tratamente;

    // constructorul clasei animal
    animal() {
    }

    animal(tratament[] tratamente) {
        // clone the array
        this.tratamente = new tratament[tratamente.length];
        for (int i = 0; i < tratamente.length; i++) {
            this.tratamente[i] = new tratament(tratamente[i]);
        }
    }

    abstract int factura();

    // suprascrierea metodei toString
    public String toString() {
        String s = "Animalul " + tip + " are tratamentele: ";
        for (int i = 0; i < tratamente.length; i++) {
            s += tratamente[i].descriere + " ";
        }
        s += "si pretul facturii este " + factura();
        return s;
    }
}

// clasa caine, extinde clasa animal, si implementeaza metoda factura
class caine extends animal {
    // constructorul clasei caine
    caine() {
        tip = "caine";
    }

    caine(tratament[] tratamente) {
        // call constructor of parent class
        super(tratamente);
        tip = "caine";
    }

    int factura() {
        int total = 0;
        for (int i = 0; i < tratamente.length; i++) {
            total += tratamente[i].pret;
        }
        return total * 2;
    }
}

// clasa pisica, extinde clasa animal, si implementeaza metoda factura
class pisica extends animal {
    // cpnstructorul clasei pisica
    pisica() {
        tip = "pisica";
    }

    pisica(tratament[] tratamente) {
        // call constructor of parent class
        super(tratamente);
        tip = "pisica";
    }

    int factura() {
        int total = 0;
        for (int i = 0; i < tratamente.length; i++) {
            total += tratamente[i].pret;
        }
        return total * 3;
    }
}

// clasa papagal, extinde clasa animal, si implementeaza metoda factura
class papagal extends animal {
    // constructorul clasei papagal
    papagal() {
        tip = "papagal";
    }

    papagal(tratament[] tratamente) {
        // call constructor of parent class
        super(tratamente);
        tip = "papagal";
    }

    int factura() {
        int total = 0;
        for (int i = 0; i < tratamente.length; i++) {
            total += tratamente[i].pret;
        }
        return total * 4;
    }
}
