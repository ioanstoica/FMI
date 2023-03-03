
// read n names from file ex3.txt and print sorted names
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;

public class ex3 {
    public static void main(String[] args) throws FileNotFoundException {
        // read n names from file ex3.txt and print sorted names
        Scanner in = new Scanner(new File("ex3.txt"));
        int n = in.nextInt();
        String[] arr = new String[n];
        for (int i = 0; i < n; i++) {
            arr[i] = in.next();
        }
        Arrays.sort(arr);
        for (int i = 0; i < n; i++) {
            System.out.println(arr[i]);
        }
        in.close();
    }
}
