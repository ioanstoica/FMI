import java.util.Scanner;

public class ex1 {
    public static void main(String args[]) {
        // Using Scanner for Getting Input from User
        Scanner in = new Scanner(System.in);

        int a = in.nextInt();
        int b = in.nextInt();

        System.out.println("Avrage of two numbers is: " + (a + b) / 2);

        in.close();

    }
}