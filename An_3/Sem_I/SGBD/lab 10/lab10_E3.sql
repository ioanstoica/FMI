-- E3.a. Introduceți în tabelul info_dept_ist coloana numar care va reprezenta pentru fiecare
-- departament numărul de angajați care lucrează în departamentul respectiv. Populați cu date
-- această coloană pe baza informațiilor din schemă.
-- b. Definiți un declanșator care va actualiza automat această coloană în funcție de actualizările
-- realizate asupra tabelului info_emp_ist.

CREATE OR REPLACE TRIGGER update_numar_angajati_ist