interface TermenGeneral {
   int calculTermen(int i);
}

class liniar implements TermenGeneral {
   public int calculTermen(int i) {
      return i;
   }
}

class patrat implements TermenGeneral {
   public int calculTermen(int i) {
      return i * i;
   }
}

class Suma {
   int calculSuma(TermenGeneral t, int n) {
      int s = 0;
      for (int i = 1; i <= n; i++) {
         s += t.calculTermen(i);
      }
      return s;
   }
}

public class calc_suma {
   public static void main(String args[]) {
      System.out.println("Hello World!");
      Suma s = new Suma();
      System.out.println(s.calculSuma(new liniar(), 10));
      System.out.println(s.calculSuma(new patrat(), 10));
   };
}
