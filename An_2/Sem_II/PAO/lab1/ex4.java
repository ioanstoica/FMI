
// read n names from file ex3.txt and print sorted names
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;

public class ex4 {
    public static void main(String[] args) throws FileNotFoundException {
        // read n names from file ex4.txt and print sorted names
        Scanner in = new Scanner(new File("ex4.txt"));
        int n = in.nextInt();
        String[] arr = new String[n];
        for (int i = 0; i < n; i++) {
            arr[i] = in.next();
            // if arr[i] ends with "escu", toUpperCase() all letters
            if (arr[i].endsWith("escu")) {
                arr[i] = arr[i].toUpperCase();
            }
        }
        Arrays.sort(arr);
        for (int i = 0; i < n; i++) {
            System.out.println(arr[i]);
        }
        in.close();
    }
}
