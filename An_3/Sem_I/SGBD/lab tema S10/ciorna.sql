-- E2. Adaptați cerința exercițiului 3 din partea I (pachete definite de utilizator) pentru diagrama
-- proiectului prezentată la materia Baze de Date din anul I. Rezolvați acest exercițiu în PL/SQL,
-- folosind baza de date proprie.

-- Partea I. Pachete definite de utilizator
-- Exercitiul 3. Definiţi un pachet cu ajutorul căruia să se obţină salariul maxim înregistrat pentru salariaţii care
-- lucrează într-un anumit oraş şi lista salariaţilor care au salariul mai mare sau egal decât acel
-- maxim. Pachetul va conţine un cursor şi un subprogram funcţie.

CREATE OR REPLACE PACKAGE PACHET3_IST AS
    CURSOR C_EMP(
        NR NUMBER
    ) RETURN EMPLOYEES%ROWTYPE;

    FUNCTION F_MAX (
        V_ORAS LOCATIONS.CITY%TYPE
    ) RETURN NUMBER;
END PACHET3_IST;
/

CREATE OR REPLACE PACKAGE BODY PACHET3_IST AS
    CURSOR C_EMP(
        NR NUMBER
    ) RETURN EMPLOYEES%ROWTYPE IS
    SELECT
        *
    FROM
        EMPLOYEES
    WHERE
        SALARY >= NR;

    FUNCTION F_MAX (
        V_ORAS LOCATIONS.CITY%TYPE
    ) RETURN NUMBER IS
        MAXIM NUMBER;
    BEGIN
        SELECT
            MAX(SALARY) INTO MAXIM
        FROM
            EMPLOYEES   E,
            DEPARTMENTS D,
            LOCATIONS   L
        WHERE
            E.DEPARTMENT_ID=D.DEPARTMENT_ID
            AND D.LOCATION_ID=L.LOCATION_ID
            AND UPPER(CITY)=UPPER(V_ORAS);
        RETURN MAXIM;
    END F_MAX;
END PACHET3_IST;
/

DECLARE
    ORAS    LOCATIONS.CITY%TYPE:= 'Toronto';
    VAL_MAX NUMBER;
    LISTA   EMPLOYEES%ROWTYPE;
BEGIN
    VAL_MAX:= PACHET3_IST.F_MAX(ORAS);
    FOR V_CURSOR IN PACHET3_IST.C_EMP(VAL_MAX) LOOP
        DBMS_OUTPUT.PUT_LINE(V_CURSOR.LAST_NAME
                             ||' '
                             || V_CURSOR.SALARY);
    END LOOP;
END;
/

-- Cerinta definita de mine:  Definiţi un pachet cu ajutorul căruia sa se afle activul cel mai cumparat. Gastiti id-ul activului in campul buy din tabela tranzactii. Valoare cumparata se calculeaza ca tranzactii.pret * tranzactii.volum unde tranzactii.buy = id_activ. Afisati id-ul activului, tranzactiile efectuate cu acel activ si valoarea totala cumparata.

-- Pachetul va conţine un cursor şi un subprogram funcţie.

-- Table: Tranzactii
CREATE TABLE TRANZACTII (
    ID_TRANZACTIE INT NOT NULL,
    DATA DATE NOT NULL,
    SELL INT NOT NULL,
    BUY INT NOT NULL,
    PRET NUMBER(10, 4) NOT NULL,
    VOLUM NUMBER(10, 4) NOT NULL,
    BROKER INT NOT NULL,
    BROKERI_ID_BROKER INT NOT NULL,
    CONSTRAINT ID_TRANZACTIE PRIMARY KEY (ID_TRANZACTIE)
);

-- pachetul:
CREATE OR REPLACE PACKAGE PACHET_ACTIV AS
 -- Cursor pentru listarea tranzacțiilor unui anumit activ
    CURSOR C_TRANZACTII(
        ID_ACTIV INT
    ) RETURN TRANZACTII%ROWTYPE;
 -- Funcție pentru găsirea activului cel mai cumpărat
    FUNCTION F_ACTIV_MAXIM RETURN INT;
END PACHET_ACTIV;
/

CREATE OR REPLACE PACKAGE BODY PACHET_ACTIV AS
    CURSOR C_TRANZACTII(
        ID_ACTIV INT
    ) RETURN TRANZACTII%ROWTYPE IS
    SELECT
        *
    FROM
        TRANZACTII
    WHERE
        BUY = ID_ACTIV;

    FUNCTION F_ACTIV_MAXIM RETURN INT IS
        ID_MAX   INT;
        VAL_MAX  NUMBER := 0;
        TEMP_VAL NUMBER;
    BEGIN
        FOR R IN (
            SELECT
                BUY,
                SUM(PRET * VOLUM) AS TOTAL_VALOARE
            FROM
                TRANZACTII
            GROUP BY
                BUY
        ) LOOP
            IF R.TOTAL_VALOARE > VAL_MAX THEN
                VAL_MAX := R.TOTAL_VALOARE;
                ID_MAX := R.BUY;
            END IF;
        END LOOP;

        RETURN ID_MAX;
    END F_ACTIV_MAXIM;
END PACHET_ACTIV;
/

-- apelare
DECLARE
    ID_ACTIV_MAX  INT;
    TOTAL_VALOARE NUMBER;
BEGIN
    ID_ACTIV_MAX := PACHET_ACTIV.F_ACTIV_MAXIM;
    DBMS_OUTPUT.PUT_LINE('Activul cel mai cumparat: '
                         || ID_ACTIV_MAX);
    FOR V_CURSOR IN PACHET_ACTIV.C_TRANZACTII(ID_ACTIV_MAX) LOOP
        DBMS_OUTPUT.PUT_LINE('Tranzactie: '
                             || V_CURSOR.ID_TRANZACTIE
                             || ', Data: '
                             || V_CURSOR.DATA
                             || ', Pret: '
                             || V_CURSOR.PRET
                             || ', Volum: '
                             || V_CURSOR.VOLUM);
    END LOOP;
END;
/