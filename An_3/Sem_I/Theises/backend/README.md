Activare mediu virtual python:
 - .\venv\Scripts\activate

Activare server django:
 - python manage.py runserver

Creare aplicatie:
 - python manage.py startapp <app_name>

 python manage.py makemigrations products
 python manage.py sqlmigrate products 0001
 python manage.py migrate

Task-uri realizate:
 - Doar utilizatorii logati au acces la detaliile produselor
 - Am adugat mai multe detalii pentru un produs
 - Am adaugat cautarea de produse noi
 - chat global si temporar https://www.geeksforgeeks.org/realtime-chat-app-using-django/
 - coprimarea login, logout, register intr-un modul separat
 - crearea unui meniu pentru navigare
 - adaugarea de elemente statice + style bootstrap
 - css pentru chat https://mdbootstrap.com/docs/standard/extended/chat/
 - de mutat styleurile pt chat
 - de afisat dreapta stanga in chat

De realizat:
 - Eroare: cand sunt pe pagina de produse, nu pot sa dau click pe toate linkurile din meniu 
 - pagina de produse sa afisze linkuril prouduselor, in dreptul fiecarui link, sa afiseze un buton de procesare
 - in urma procesarii, sa iti afiseze inca un link, care sa te duca la noul produs
 - si sa mai afiseze 2 label-uri, cu profitabilitatea produsului, si cu nivelul de similitudine cu produsul original
