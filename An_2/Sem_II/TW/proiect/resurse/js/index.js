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

   // CERINTA: validarea datelor dintr-un formular folosind expresii regulate
   // Expresia regulată care caută tag-urile de script
   var scriptRegex = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;

   // Verifică dacă textul introdus conține un script
   if (scriptRegex.test(commentText)) {
      alert("Comentariul nu poate conține script-uri!");
      commentInput.value = "";
      return;
   }

   if (commentText !== "") {
      var commentList = document.getElementById("comment-list");

      var newComment = document.createElement("li");
      var commentTextNode = document.createTextNode(commentText);
      newComment.appendChild(commentTextNode);

      // Creează butonul de ștergere
      var deleteButton = document.createElement("button");
      deleteButton.textContent = "Șterge";
      deleteButton.addEventListener("click", function () {
         // Șterge comentariul din lista de comentarii
         comments.splice(comments.indexOf(commentText), 1);
         // Salvează lista de comentarii în localStorage
         localStorage.setItem("comments", JSON.stringify(comments));
         newComment.remove();
      });

      // Adaugă butonul de ștergere înaintea textului comentariului
      newComment.insertBefore(deleteButton, commentTextNode);

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

         addDeleteButton(newComment, i); // Adaugă butonul de ștergere la elementul li

         var spaceNode = document.createTextNode(" "); // Creează un nod de text cu un spațiu
         newComment.appendChild(spaceNode); // Adaugă spațiul după butonul de ștergere


         var commentTextNode = document.createTextNode(comments[i]);
         newComment.appendChild(commentTextNode); // Adaugă textul comentariului după butonul de ștergere

         commentList.appendChild(newComment);
      }
   }
}


// CERINTA: folosirea a cel puțin unei metode din clasele: Math, Array, String, Date
var data = new Date();

// modifica valoarea tag-ului time cu id-ul id="time_now" cu data si ora curenta
document.getElementById("time_now").innerHTML = data.toLocaleString();

// CERINTA: schimbarea aleatoare a valorilor unor proprietăți (de exemplu: culoare, dimensiuni, poziție)
/* alege o culoare random pentru textul din h2 */
var colors = ["red", "green", "blue", "yellow", "orange", "purple", "pink", "brown", "black", "gray"];
var randomColor = colors[Math.floor(Math.random() * colors.length)];
document.getElementById("random_color").style.color = randomColor;


// CERINTA: folosirea proprietăților classList, target sau currentTarget
// adauga clasa "rich_text" elementelor <h2> din pagina
var paragraphs = document.getElementsByTagName("h2");
for (var i = 0; i < paragraphs.length; i++) {
   paragraphs[i].classList.add("rich_text");
}

// CERINTA: folosirea metodelor getComputedStyle și stopPropagation
// afiseaza in consola proprietatea "color" a elementului cu id-ul "random_color"
var randomColorElement = document.getElementById("random_color");
var randomColorElementStyle = window.getComputedStyle(randomColorElement);
console.log(randomColorElementStyle.color);

// stopPropagation
document.getElementById("random_color").addEventListener("click", function (event) {
   alert("Ai apăsat pe textul colorat!");
   event.stopPropagation();
});
