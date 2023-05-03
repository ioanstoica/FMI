
function handleKeyPress(event) {
   const vizor = document.getElementById("vizor");
   const image = vizor.getElementsByTagName("img")[0];
   const step = 10; // numărul de pixeli cu care se va deplasa imaginea

   // print the key that was pressed
   console.log(event.code);

   // move the image
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

   // zoom 
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


   // take a picture
   if (event.code === "KeyS") {
      const clone = vizor.cloneNode(true); // obiect copie a elementului div vizor
      clone.style.position = "absolute";
      clone.style.clip = "rect(0px," + vizor.offsetWidth + "px," + vizor.offsetHeight + "px,0px)";
      document.body.appendChild(clone);

      // Redăm sunetul de declanșare a camerei
      const audio = new Audio('camera-shutter-click.mp3');
      audio.play();

      // Animăm clip-ul pentru a simula un efect de obturator
      image.style.filter = "blur(5px)";
      vizor.style.clip = "rect(0px,0px,0px,0px)";
      vizor.style.transition = "clip 0.5s ease-in-out";
      setTimeout(function () {
         vizor.style.clip = "rect(" + vizor.offsetHeight + "px," + vizor.offsetWidth + "px," + vizor.offsetHeight + "px,0px)";
         vizor.style.transition = "clip 0.5s ease-in-out";
         image.style.filter = "none";
      }, 500);

      // Adăugăm imaginea la galerie
      const galerie = document.getElementById("galerie");
      const img = document.createElement("img");
      img.src = clone.getElementsByTagName("img")[0].src;
      galerie.insertBefore(img, galerie.firstChild);

      return clone;
   }

   return;
}

// Adăugăm un eveniment de ascultare pentru tastatura
addEventListener("keydown", handleKeyPress);

