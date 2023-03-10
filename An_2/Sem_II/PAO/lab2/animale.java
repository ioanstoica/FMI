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
            tratamente[i] = new tratament();
            tratamente[i].pret = in.nextInt();
            tratamente[i].descriere = in.next();
        }
        in.close();

        // afisam tratamentele
        for (int i = 0; i < n; i++) {
            System.out.println(tratamente[i].pret + " " + tratamente[i].descriere);
        }
    }
}

// clasa tratament, cu campurile descriere si pret
class tratament {
    String descriere;
    int pret;
}

// clasa abstracta animal, cu campurile tip, lista tratamente, si o metoda
// abstracta factura
abstract class animal {
    String tip;
    tratament[] tratamente;

    abstract int factura();
}

// clasa caine, extinde clasa animal, si implementeaza metoda factura
class caine extends animal {
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
    int factura() {
        int total = 0;
        for (int i = 0; i < tratamente.length; i++) {
            total += tratamente[i].pret;
        }
        return total * 4;
    }
}
