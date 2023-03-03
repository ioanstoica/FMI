import java.util.Scanner;
import java.util.Arrays;
import java.io.File;
import java.io.FileNotFoundException;

public class ex2 {
    public static void main(String[] args) throws FileNotFoundException {
        // read n number from user and print the average and the sorted array
        // Scanner in = new Scanner(System.in);
        Scanner in = new Scanner(new File("ex2.txt"));
        int n = in.nextInt();
        int[] arr = new int[n];
        int sum = 0;
        for (int i = 0; i < n; i++) {
            arr[i] = in.nextInt();
            sum += arr[i];
        }
        System.out.println("The average of the numbers is: " + (sum / n));

        // // var 1
        // for (int i = 0; i < n; i++) {
        // for (int j = i + 1; j < n; j++) {
        // if (arr[i] > arr[j]) {
        // int temp = arr[i];
        // arr[i] = arr[j];
        // arr[j] = temp;
        // }
        // }
        // }

        // var 2
        // use Arrays.sort(arr);
        Arrays.sort(arr);

        System.out.println("Sorted array is: ");
        for (int i = 0; i < n; i++) {
            System.out.print(arr[i] + " ");
        }
        in.close();
    }
}
