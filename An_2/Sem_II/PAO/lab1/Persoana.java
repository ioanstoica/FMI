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
        return AnCurent - AnNastere + 100000;
    }
}