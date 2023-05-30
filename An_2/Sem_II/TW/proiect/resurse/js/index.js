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

// CERINTA: folosirea localStorage (să se pastreze în localStorage o colecție de elemente)
// declaram un Array de String-uri
var comments = []; // Array-ul de comentarii

// CERINTA: crearea și stergerea de elemente HTML
function addDeleteButton(commentElement, index) {
   var deleteButton = document.createElement("button");
   deleteButton.innerHTML = "Șterge";
   deleteButton.addEventListener("click", function () {
      // Șterge comentariul din lista de comentarii
      comments.splice(index, 1);
      // Salvează lista de comentarii în localStorage
      localStorage.setItem("comments", JSON.stringify(comments));
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

      addDeleteButton(newComment, comments.length); // Adaugă butonul de ștergere la comentariu

      commentList.appendChild(newComment);

      commentInput.value = "";

      // Adaugă comentariul în lista de comentarii
      comments.push(commentText);

      // Salvează lista de comentarii în localStorage
      localStorage.setItem("comments", JSON.stringify(comments));
   }
}

// Eveniment pentru trimiterea formularului de comentarii
document.getElementById("comment-form").addEventListener("submit", function (event) {
   event.preventDefault(); // Previne acțiunea implicită de trimitere a formularului
   addComment(); // Adaugă comentariul
});

// CERINTA: folosirea și modificarea evenimentelor generate de mouse si tastatură
var image = document.getElementById("dark-theme");

image.addEventListener("mouseover", function () {
   image.style.transform = "scale(1.3)";
});

image.addEventListener("mouseout", function () {
   image.style.transform = "scale(1)";
});

// CERINTA: folosirea setTimeout sau setInterval
function afișeazăMesaj() {
   // alert("Pagina are acum un buton pentru a schimba tema!");
   darkThemeButton.style.height = "50px";
   darkThemeButton.style.width = "50px";
}

setTimeout(afișeazăMesaj, 2000);


// cand se incarca pagina, se apeleaza functia de afisare a comentariilor
window.onload = function () {
   afiseazaComentarii();
}

// functia de afisare a comentariilor din localStorage
function afiseazaComentarii() {
   // se verifica daca exista comentarii in localStorage
   if (localStorage.getItem("comments")) {
      // se preiau comentariile din localStorage
      comments = JSON.parse(localStorage.getItem("comments"));
      // se afiseaza comentariile
      for (var i = 0; i < comments.length; i++) {
         var commentList = document.getElementById("comment-list");
         var newComment = document.createElement("li");
         newComment.innerHTML = comments[i];
         addDeleteButton(newComment, i);
         commentList.appendChild(newComment);
      }
   }
}


// CERINTA: folosirea a cel puțin unei metode din clasele: Math, Array, String, Date
var data = new Date();

// modifica valoarea tag-ului time cu id-ul id="time_now" cu data si ora curenta
document.getElementById("time_now").innerHTML = data.toLocaleString();
