
function handleKeyPress(event) {
   const vizor = document.getElementById("vizor");
   const image = vizor.getElementsByTagName("img")[0];
   const step = 10; // numărul de pixeli cu care se va deplasa imaginea

   // print the key that was pressed
   console.log(event.code);

   // Verificăm codul tastelor de direcție și actualizăm poziția imaginii în consecință
   switch (event.code) {
      case "ArrowLeft":
         image.style.transform = `translateX(-${step}px)`;
         break;
      case "ArrowRight":
         image.style.transform = `translateX(${step}px)`;
         break;
      case "ArrowUp":
         image.style.transform = `translateY(-${step}px)`;
         break;
      case "ArrowDown":
         image.style.transform = `translateY(${step}px)`;
         break;
      default:
         return;
   }
}

// Adăugăm un eveniment de ascultare pentru tastatura
addEventListener("keydown", handleKeyPress);

