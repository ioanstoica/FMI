public class ex6 {
    public static void main(String[] args) {
        Persoana[] arr = new Persoana[3];
        arr[0] = new Persoana("Ion", 1990, 1000);
        arr[1] = new Persoana("Gheorghe", 1995, 2000);
        arr[2] = new Persoana("Maria", 1992, 3000);
        for (int i = 0; i < 3; i++) {
            System.out.println(arr[i].getNume() + " " + arr[i].getVarsta() + " " + arr[i].getSalariu());
        }

        // calculare salariu mediu
        int sum = 0;
        for (int i = 0; i < 3; i++) {
            sum += arr[i].getSalariu();
        }
        System.out.println("Salariul mediu este: " + (sum / 3));

        // replace "Gheorghe" with "George"
        for (int i = 0; i < 3; i++) {
            if (arr[i].getNume().equals("Gheorghe")) {
                arr[i].setNume("George");
            }
        }
        System.out.println();
        System.out.println("Noul nume este::: " + arr[1].getNume());
        for (int i = 0; i < 3; i++) {
            System.out.println(arr[i].getNume() + " " + arr[i].getVarsta() + " " + arr[i].getSalariu());
        }

    }
}
