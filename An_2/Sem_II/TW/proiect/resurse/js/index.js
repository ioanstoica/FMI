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
// Funcție pentru a adăuga un comentariu în lista de comentarii
function addComment() {
   var commentInput = document.getElementById("comment-input");
   var commentText = commentInput.value;

   if (commentText !== "") {
      var commentList = document.getElementById("comment-list");

      var newComment = document.createElement("li");
      newComment.innerHTML = commentText;

      commentList.appendChild(newComment);

      commentInput.value = "";
   }
}

// Eveniment pentru trimiterea formularului de comentarii
document.getElementById("comment-form").addEventListener("submit", function (event) {
   event.preventDefault(); // Previne acțiunea implicită de trimitere a formularului
   addComment(); // Adaugă comentariul
});
