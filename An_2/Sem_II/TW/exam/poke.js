//  poke.json :
// [{"name":"Mew", "ability":"Synchronize", "level":"4", "image":"https://upload.wikimedia.org/wikipedia/en/4/4b/Pok%C3%A9mon_Mew_art.png"},] 
// La apăsarea bilei, se va alege un pokemon din lista de pokemoni din fișierul poke.json (care poate fi descărcat din directorul resources). Folosiți fetch și promisiuni pentru a accesa conținutul fișierului pe un server http local (porniți un server http folosind, de exemplu, Python). La fiecare click pe bilă, se va alege aleator unul din pokemoni și se va afișa sub bilă un mesaj de forma "Nume-pokemon, I choose you! (number selections)". Numele pokemonului va fi extras din fișierul .json, iar numărul de selecții (de câte ori a fost ales pokemonul curent) va fi contorizat folosind sessionStorage.

// la fiecare click pe obiectul din clasa pokeball se va memora in sessionStorage numarul de clickuri

choosePokeball = document.querySelector(".pokeball");
choosePokeball.addEventListener("click", choosePokemon);

function choosePokemon() {
   fetch("http://localhost:3000/poke.json")
      .then(response => response.json())
      .then(data => {
         let randomPokemon = Math.floor(Math.random() * data.length);
         let pokemonName = data[randomPokemon].name;
         let pokemonImage = data[randomPokemon].image;
         let pokemonAbility = data[randomPokemon].ability;
         let pokemonLevel = data[randomPokemon].level;
         let pokemon = new Pokemon(pokemonName, pokemonImage, pokemonAbility, pokemonLevel);
         pokemon.displayPokemon();
      })
      .catch(error => console.log(error));
}

