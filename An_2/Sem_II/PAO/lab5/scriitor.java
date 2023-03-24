interface Writer {
   default void write() {
      System.out.println("I am a writer");
   };
}

interface Poet {
   default void write() {
      System.out.println("I am a poet");
   };
}

class Multitalented implements Writer, Poet {
   public void write() {
      Writer.super.write();
   }
}

public class scriitor {
   // print "Hello World!"
   public static void main(String args[]) {
      System.out.println("Hello World!");
      Multitalented m = new Multitalented();
      m.write();
   };
}
