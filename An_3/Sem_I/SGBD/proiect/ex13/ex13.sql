-- Definiți un pachet care să conțină toate obiectele definite în cadrul proiectului.


CREATE OR REPLACE PACKAGE MY_PACKAGE AS
 -- ex 6
    PROCEDURE EXTRAGE_ACTIVE;
 -- ex 7
    PROCEDURE VOLUM_MAXIM;
 -- ex 8
    FUNCTION AFISEAZA_BLOCKCHAIN_CRIPTOMONEDA_MAX RETURN VARCHAR2;
 -- ex 9
    PROCEDURE MOST_EXPENSIVE_INVESTMENT(
        ACTIUNE CHAR,
        OBLIGATIUNE CHAR,
        CRIPTOMONEDA INT,
        ETF CHAR
    );
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
 -- ex 7
    PROCEDURE VOLUM_MAXIM AS
        CURSOR C1(
            V_VOLUM NUMBER
        ) IS
        SELECT
            COUNT(*) AS NR_TRANZACTII
        FROM
            TRANZACTII
        WHERE
            VOLUM = V_VOLUM;
        CURSOR C2 IS
        SELECT
            MAX(VOLUM) AS MAX_VOLUM
        FROM
            TRANZACTII;
        V_MAX_VOLUM     NUMBER;
        V_NR_TRANZACTII NUMBER;
    BEGIN
        OPEN C2;
        FETCH C2 INTO V_MAX_VOLUM;
        CLOSE C2;
        OPEN C1(V_MAX_VOLUM);
        FETCH C1 INTO V_NR_TRANZACTII;
        CLOSE C1;
        DBMS_OUTPUT.PUT_LINE('Tranzactiile cu volumul egal cu volumul maxim al unei tranzactii sunt: '
                             || V_NR_TRANZACTII);
    END;
 -- ex 8
    FUNCTION AFISEAZA_BLOCKCHAIN_CRIPTOMONEDA_MAX RETURN VARCHAR2 IS
 -- Definirea excepțiilor
        CRYPTO_NEEXISTENT EXCEPTION;
        BLOCKCHAIN_NEEXISTENT EXCEPTION;
 -- Variabile
        ID_CRIPTOMONEDA_MAX   INT;
        ID_BLOCKCHAIN_MAX     INT;
        NUME_BLOCKCHAIN       VARCHAR2(20);
    BEGIN
        BEGIN
 -- Căutăm criptomoneda de tip 'Crypto' cu cel mai mare preț
            SELECT
                ID_ACTIV INTO ID_CRIPTOMONEDA_MAX
            FROM
                ACTIVE
            WHERE
                TIP = 'Crypto'
            ORDER BY
                PRET DESC FETCH FIRST ROW ONLY;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE CRYPTO_NEEXISTENT;
        END;

        DBMS_OUTPUT.PUT_LINE('criptomoneda gasita: '
                             || ID_CRIPTOMONEDA_MAX);
        BEGIN
 -- Căutăm blockchain-ul pe care este listată criptomoneda
            SELECT
                B.ID_BLOCKCHAIN INTO ID_BLOCKCHAIN_MAX
            FROM
                CRIPTOMONEDE C
                JOIN BLOCKCHAIN B
                ON C.BLOCKCHAIN = B.ID_BLOCKCHAIN
            WHERE
                C.ID_CRIPTOMONEDA = ID_CRIPTOMONEDA_MAX;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE BLOCKCHAIN_NEEXISTENT;
        END;

        SELECT
            A.NUME INTO NUME_BLOCKCHAIN
        FROM
            BLOCKCHAIN A
        WHERE
            A.ID_BLOCKCHAIN = ID_BLOCKCHAIN_MAX;
 -- Returnăm numele blockchain-ului
        RETURN NUME_BLOCKCHAIN;
    EXCEPTION
        WHEN CRYPTO_NEEXISTENT THEN
            RETURN 'Nu există Active de tipul Crypto.';
        WHEN BLOCKCHAIN_NEEXISTENT THEN
            RETURN 'Criptomoneda găsită nu este listată pe niciun blockchain.';
        WHEN NO_DATA_FOUND THEN
            RETURN 'NO_DATA_FOUND';
        WHEN OTHERS THEN
            RETURN 'A apărut o eroare neașteptată.';
    END AFISEAZA_BLOCKCHAIN_CRIPTOMONEDA_MAX;
 -- ex 9
    PROCEDURE MOST_EXPENSIVE_INVESTMENT(
        ACTIUNE CHAR,
        OBLIGATIUNE CHAR,
        CRIPTOMONEDA INT,
        ETF CHAR
    ) IS
        ACTIUNE_ID        INT;
        OBLIGATIUNE_ID    NUMBER;
        CRIPTOMONEDA_ID   NUMBER;
        ETF_ID            NUMBER;
        PRET_ACTIUNE      NUMBER;
        PRET_OBLIGATIUNE  NUMBER;
        PRET_CRIPTOMONEDA NUMBER;
        PRET_ETF          NUMBER;
    BEGIN
        SELECT
            ID_ACTIUNE INTO ACTIUNE_ID
        FROM
            ACTIUNI
        WHERE
            COMPANIE = ACTIUNE;
        SELECT
            ID_OBLIGATIUNE INTO OBLIGATIUNE_ID
        FROM
            OBLIGATIUNI
        WHERE
            EMITENT = OBLIGATIUNE;
        SELECT
            ID_CRIPTOMONEDA INTO CRIPTOMONEDA_ID
        FROM
            CRIPTOMONEDE
        WHERE
            CHEIE = CRIPTOMONEDA;
        SELECT
            ID_ETF INTO ETF_ID
        FROM
            ETFURI
        WHERE
            EMITENT = ETF;
        SELECT
            PRET INTO PRET_ACTIUNE
        FROM
            ACTIVE
        WHERE
            ID_ACTIV = ACTIUNE_ID;
        SELECT
            PRET INTO PRET_OBLIGATIUNE
        FROM
            ACTIVE
        WHERE
            ID_ACTIV = OBLIGATIUNE_ID;
        SELECT
            PRET INTO PRET_CRIPTOMONEDA
        FROM
            ACTIVE
        WHERE
            ID_ACTIV = CRIPTOMONEDA_ID;
        SELECT
            PRET INTO PRET_ETF
        FROM
            ACTIVE
        WHERE
            ID_ACTIV = ETF_ID;
        IF PRET_ACTIUNE > PRET_OBLIGATIUNE AND PRET_ACTIUNE > PRET_CRIPTOMONEDA AND PRET_ACTIUNE > PRET_ETF THEN
            DBMS_OUTPUT.PUT_LINE('Actiunea are pretul cel mai mare');
        ELSIF PRET_OBLIGATIUNE > PRET_ACTIUNE AND PRET_OBLIGATIUNE > PRET_CRIPTOMONEDA AND PRET_OBLIGATIUNE > PRET_ETF THEN
            DBMS_OUTPUT.PUT_LINE('Obligatiunea are pretul cel mai mare');
        ELSIF PRET_CRIPTOMONEDA > PRET_ACTIUNE AND PRET_CRIPTOMONEDA > PRET_OBLIGATIUNE AND PRET_CRIPTOMONEDA > PRET_ETF THEN
            DBMS_OUTPUT.PUT_LINE('Criptomoneda are pretul cel mai mare');
        ELSIF PRET_ETF > PRET_ACTIUNE AND PRET_ETF > PRET_OBLIGATIUNE AND PRET_ETF > PRET_CRIPTOMONEDA THEN
            DBMS_OUTPUT.PUT_LINE('ETF-ul are pretul cel mai mare');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Exista mai multe active cu pretul cel mai mare');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista active pentru cautarea facuta');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe active cu numele dat');
    END;
END MY_PACKAGE;
/

-- ex 6
set serveroutput on

/

-- ex 7
execute my_package.extrage_active();

/

-- ex 8
UPDATE ACTIVE
SET
    NUME = 'BTC',
    TIP = 'Crypto2',
    PRET = 60000.00
WHERE
    ID_ACTIV = 10;

/

SELECT
    MY_PACKAGE.AFISEAZA_BLOCKCHAIN_CRIPTOMONEDA_MAX()
FROM
    DUAL;

/

UPDATE ACTIVE
SET
    NUME = 'BTC',
    TIP = 'Crypto',
    PRET = 60000.00
WHERE
    ID_ACTIV = 10;

/

SELECT
    MY_PACKAGE.AFISEAZA_BLOCKCHAIN_CRIPTOMONEDA_MAX()
FROM
    DUAL;

/

-- ex 9
UPDATE ACTIUNI
SET
    COMPANIE = 'Tesla'
WHERE
    ID_ACTIUNE = 2;
/

BEGIN
    MY_PACKAGE.MOST_EXPENSIVE_INVESTMENT('Appdle', 'SUA', 345678, 'Fidelity');
END;
/

BEGIN
    MY_PACKAGE.MOST_EXPENSIVE_INVESTMENT('Apple', 'SUA', 345678, 'Fidelity');
END;
/

UPDATE ACTIUNI
SET
    COMPANIE = 'Apple'
WHERE
    ID_ACTIUNE = 2;
/
BEGIN
    MY_PACKAGE.MOST_EXPENSIVE_INVESTMENT('Apple', 'SUA', 345678, 'Fidelity');
END;
/