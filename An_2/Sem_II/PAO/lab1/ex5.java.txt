class Persoana {
    private String nume;
    private int AnNastere;
    private int Salariu;
    private static int AnCurent = 2023;

    public Persoana(String nume, int anNastere, int salariu) {
        this.nume = nume;
        AnNastere = anNastere;
        Salariu = salariu;
    }

    public String getNume() {
        return nume;
    }

    public void setNume(String nume) {
        this.nume = nume;
    }

    public int getAnNastere() {
        return AnNastere;
    }

    public void setAnNastere(int anNastere) {
        AnNastere = anNastere;
    }

    public int getSalariu() {
        return Salariu;
    }

    public void setSalariu(int salariu) {
        Salariu = salariu;
    }

    public static int getAnCurent() {
        return AnCurent;
    }

    public static void setAnCurent(int anCurent) {
        AnCurent = anCurent;
    }

    public int getVarsta() {
        return AnCurent - AnNastere;
    }
}

public class ex5 {
    public static void main(String[] args) {
        Persoana[] arr = new Persoana[3];
        arr[0] = new Persoana("Ion", 1990, 1000);
        arr[1] = new Persoana("Gheorghe", 1995, 2000);
        arr[2] = new Persoana("Maria", 1992, 3000);
        for (int i = 0; i < 3; i++) {
            System.out.println(arr[i].getNume() + " " + arr[i].getVarsta() + " " + arr[i].getSalariu());
        }

        System.out.println("Varsta lui Ion este: " + arr[0].getVarsta());
        System.out.println("Varsta lui Gheorghe este: " + arr[1].getVarsta());
        System.out.println("Varsta Mariei este: " + arr[2].getVarsta());

        // calculare salariu mediu
        int sum = 0;
        for (int i = 0; i < 3; i++) {
            sum += arr[i].getSalariu();
        }
        System.out.println("Salariul mediu este: " + (sum / 3));
    }
}
