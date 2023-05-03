
function handleKeyPress(event) {
   const vizor = document.getElementById("vizor");
   const image = vizor.getElementsByTagName("img")[0];
   const step = 10; // numărul de pixeli cu care se va deplasa imaginea

   // print the key that was pressed
   console.log(event.code);

   // Obținem valorile curente ale marginilor imaginii
   const currentMarginTop = parseInt(image.style.marginTop) || 0;
   const currentMarginLeft = parseInt(image.style.marginLeft) || 0;

   // Verificăm codul tastelor de direcție și actualizăm marginile imaginii în consecință
   switch (event.code) {
      case "ArrowLeft":
         image.style.marginLeft = `${currentMarginLeft - step}px`;
         break;
      case "ArrowRight":
         image.style.marginLeft = `${currentMarginLeft + step}px`;
         break;
      case "ArrowUp":
         image.style.marginTop = `${currentMarginTop - step}px`;
         break;
      case "ArrowDown":
         image.style.marginTop = `${currentMarginTop + step}px`;
         break;

   }

   // let scale = 1; // zoom implicit
   scale = parseFloat(image.style.transform.replace("scale(", "")) || 1;

   if (event.code === "Equal" && event.shiftKey) {
      // Dacă apăsăm "+" (shift + =), mărim zoom-ul cu 10%
      scale += 0.1;
   } else if (event.code === "Minus" && event.shiftKey) {
      // Dacă apăsăm "shift" si "-", micșorăm zoom-ul cu 10%
      scale -= 0.1;
   }

   // Actualizăm transformarea CSS pentru a aplica zoom-ul
   image.style.transform = `scale(${scale})`;


   return;
}

// Adăugăm un eveniment de ascultare pentru tastatura
addEventListener("keydown", handleKeyPress);

