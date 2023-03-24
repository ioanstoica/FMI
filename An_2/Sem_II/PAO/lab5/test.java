interface Polygon {
   Double area();

   Double perimetre();
}

class Triangle implements Polygon {
   Double a, b, c;

   public Triangle(Double a, Double b, Double c) {
      this.a = a;
      this.b = b;
      this.c = c;
   }

   public Double area() {
      Double s = (a + b + c) / 2;
      return Math.sqrt(s * (s - a) * (s - b) * (s - c));
   }

   public Double perimetre() {
      return a + b + c;
   }
}

// print "Hello World!"
public class test {
   public static void main(String args[]) {
      System.out.println("Hello World!");
      Polygon p = new Triangle(5.0, 7.0, 9.0);
      System.out.println(p.area());
   };
}