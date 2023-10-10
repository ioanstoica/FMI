const http = require('http');
const axios = require('axios');
require('dotenv').config();

const hostname = '127.0.0.1';
const port = 3000;

const apiKey = process.env.API_KEY;
const address = 'Str. Academiei nr.14, 010014 București';

// Construiți URL-ul cererii de geocodare
const geocodeUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=${apiKey}`;


const server = http.createServer((req, res) => {

   // Efectuați cererea HTTP folosind axios
   axios.get(geocodeUrl)
      .then(response => {
         // Manipulați răspunsul API aici
         res.end(JSON.stringify(response.data));
         console.log(response.data);
      })
      .catch(error => {
         // Tratați erorile aici
         console.error(error);
         res.end(JSON.stringify(error));
      });


   res.statusCode = 200;
   res.setHeader('Content-Type', 'text/plain');
   //res.end('Hello World');
});

server.listen(port, hostname, () => {
   console.log(`Server running at http://${hostname}:${port}/`);
});