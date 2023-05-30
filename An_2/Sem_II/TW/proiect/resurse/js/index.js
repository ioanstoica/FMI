//  CERINTA: modificarea stilului unui element sau al unui grup de elemente 
//  CERINTA: manipularea DOM-ului (selectare după id, tag, clasă, folosind selectori CSS) 

// Obține elementul cu id-ul "dark-theme"
const darkThemeButton = document.querySelector("#dark-theme");

// Adaugă un eveniment de click pe elementul "dark-theme"
darkThemeButton.addEventListener("click", function () {
   // Obține elementul <body>
   const body = document.querySelector("body");

   // Verifică clasa curentă a elementului <body>
   if (body.classList.contains("dark")) {
      // Dacă clasa este "dark", elimină clasa și adaugă clasa "light"
      body.classList.remove("dark");
      body.classList.add("light");
   } else {
      // Altfel, elimină clasa "light" și adaugă clasa "dark"
      body.classList.remove("light");
      body.classList.add("dark");
   }
});

// CERINTA: crearea și stergerea de elemente HTML

// Funcție pentru a adăuga un buton de ștergere și gestionarea evenimentului de ștergere
function addDeleteButton(commentElement) {
   var deleteButton = document.createElement("button");
   deleteButton.innerHTML = "Șterge";
   deleteButton.addEventListener("click", function () {
      commentElement.remove();
   });
   commentElement.appendChild(deleteButton);
}

// CERINTA: modificare de proprietăți

// Funcție pentru a adăuga un comentariu în lista de comentarii
function addComment() {
   var commentInput = document.getElementById("comment-input");
   var commentText = commentInput.value;

   if (commentText !== "") {
      var commentList = document.getElementById("comment-list");

      var newComment = document.createElement("li");
      newComment.innerHTML = commentText;

      addDeleteButton(newComment); // Adaugă butonul de ștergere la comentariu

      commentList.appendChild(newComment);

      commentInput.value = "";
   }
}

// Eveniment pentru trimiterea formularului de comentarii
document.getElementById("comment-form").addEventListener("submit", function (event) {
   event.preventDefault(); // Previne acțiunea implicită de trimitere a formularului
   addComment(); // Adaugă comentariul
});

// CERINTA: folosirea și modificarea evenimentelor generate de mouse si tastatură
var image = document.getElementById("image");

image.addEventListener("mouseover", function () {
   image.style.transform = "scale(1.3)";
});

image.addEventListener("mouseout", function () {
   image.style.transform = "scale(1)";
});

