-- Definiți un pachet care să conțină toate obiectele definite în cadrul proiectului.


CREATE OR REPLACE PACKAGE MY_PACKAGE AS
 -- ex 6
    PROCEDURE EXTRAGE_ACTIVE;
END MY_PACKAGE;
/

CREATE OR REPLACE PACKAGE BODY MY_PACKAGE AS
 -- ex 6
    PROCEDURE EXTRAGE_ACTIVE AS
        TYPE T_INDEXBY_TABLE IS
            TABLE OF INT INDEX BY PLS_INTEGER;
        TYPE T_NESTED_TABLE IS
            TABLE OF INT;
        TYPE T_VARRAY IS
            VARRAY(100) OF INT;
 -- Definirea colecțiilor
        CUMPARATE  T_INDEXBY_TABLE;
        VANDUTE    T_NESTED_TABLE := T_NESTED_TABLE(); -- Inițializare aici
        COMUNE     T_VARRAY := T_VARRAY();
        CURSOR TRANZACTII_CURSOR IS
        SELECT
            BUY,
            SELL
        FROM
            TRANZACTII;
        TRANZACTIE TRANZACTII_CURSOR%ROWTYPE;
    BEGIN
 -- Deschidem cursorul și procesăm fiecare tranzacție
        OPEN TRANZACTII_CURSOR;
        LOOP
            FETCH TRANZACTII_CURSOR INTO TRANZACTIE;
            EXIT WHEN TRANZACTII_CURSOR%NOTFOUND;
 -- Adăugăm activele în colecții
            CUMPARATE(TRANZACTIE.BUY) := TRANZACTIE.BUY;
 -- Pentru tablourile îmbrișate, utilizăm metoda EXTEND pentru a adăuga un element
            VANDUTE.EXTEND;
            VANDUTE(VANDUTE.COUNT) := TRANZACTIE.SELL;
        END LOOP;

        CLOSE TRANZACTII_CURSOR;
 -- pentru fiecare activ cumparat verificam daca a fost vandut
        FOR I IN 1..CUMPARATE.COUNT LOOP
            FOR J IN 1..VANDUTE.COUNT LOOP
                IF CUMPARATE(I) = VANDUTE(J) THEN
                    COMUNE.EXTEND;
                    COMUNE(COMUNE.COUNT) := CUMPARATE(I);
                END IF;
            END LOOP;
        END LOOP;
 -- afiseaza colectia cumparate
        DBMS_OUTPUT.PUT_LINE('Activele cumparate sunt: ');
        FOR I IN 1..CUMPARATE.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(CUMPARATE(I));
        END LOOP;
 -- afiseaza colectia vandute
        DBMS_OUTPUT.PUT_LINE('Activele vandute sunt: ');
        FOR I IN 1..VANDUTE.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(VANDUTE(I));
        END LOOP;
 -- afiseaza colectia comune
        DBMS_OUTPUT.PUT_LINE('Activele care au fost si cumparate si vandute sunt: ');
        FOR I IN 1..COMUNE.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(COMUNE(I));
        END LOOP;
    END EXTRAGE_ACTIVE;
END MY_PACKAGE;
/

set serveroutput on

/

execute my_package.extrage_active();

/