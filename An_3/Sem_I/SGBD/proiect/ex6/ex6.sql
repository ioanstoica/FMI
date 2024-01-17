-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent care să utilizeze toate cele 3 tipuri de colecții studiate. Apelați subprogramul.

-- Scrie un subprogram care extrage intr-o colectie activele cumparate din lista de tranzactii, in alta colectie activele vandute, iar in alta colectie activele comune primelor 2 colectii. foloseste un subprogram stocat independent care să utilizeze toate cele 3 tipuri de colecții studiate  tablouri indexate (index-by tables), tablouri imbriate ( nested table) si vectori cu dimensiuni variabile (varrays). . Apelați subprogramul.

CREATE OR REPLACE PROCEDURE extrage_active AS
    TYPE t_indexby_table IS TABLE OF INT INDEX BY PLS_INTEGER;
    TYPE t_nested_table IS TABLE OF INT;
    TYPE t_varray IS VARRAY(100) OF INT;

    -- Definirea colecțiilor
    cumparate t_indexby_table;
    vandute t_nested_table := t_nested_table(); -- Inițializare aici

    comune t_varray := t_varray();

    cursor tranzactii_cursor IS
        SELECT Buy, Sell FROM Tranzactii;

    tranzactie tranzactii_cursor%ROWTYPE;

BEGIN
    -- Deschidem cursorul și procesăm fiecare tranzacție
    OPEN tranzactii_cursor;
    LOOP
        FETCH tranzactii_cursor INTO tranzactie;
        EXIT WHEN tranzactii_cursor%NOTFOUND;

        -- Adăugăm activele în colecții
        cumparate(tranzactie.Buy) := tranzactie.Buy;
        -- Pentru tablourile îmbrișate, utilizăm metoda EXTEND pentru a adăuga un element
        vandute.EXTEND;
        vandute(vandute.COUNT) := tranzactie.Sell;

    END LOOP;
    CLOSE tranzactii_cursor;

    -- pentru fiecare activ cumparat verificam daca a fost vandut
    FOR i IN 1..cumparate.COUNT LOOP
        FOR j IN 1..vandute.COUNT LOOP
            IF cumparate(i) = vandute(j) THEN
                comune.EXTEND;
                comune(comune.COUNT) := cumparate(i);
            END IF;
        END LOOP;
    END LOOP;

    -- afiseaza colectia cumparate
    DBMS_OUTPUT.PUT_LINE('Activele cumparate sunt: ');
    FOR i IN 1..cumparate.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(cumparate(i));
    END LOOP;

    -- afiseaza colectia vandute
    DBMS_OUTPUT.PUT_LINE('Activele vandute sunt: ');
    FOR i IN 1..vandute.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(vandute(i));
    END LOOP;

    -- afiseaza colectia comune
    DBMS_OUTPUT.PUT_LINE('Activele care au fost si cumparate si vandute sunt: ');
    FOR i IN 1..comune.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(comune(i));
    END LOOP;


END extrage_active;

/

set serveroutput on
/

execute extrage_active();
/

