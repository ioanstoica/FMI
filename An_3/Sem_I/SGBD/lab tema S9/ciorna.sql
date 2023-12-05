-- Cerinta: Rezolvați exercițiul 1 folosind o procedură stocată.
-- Indicatie: Folositiva de modelul de la exercitiul 4

-- Exercitiul: 1. Definiți un subprogram prin care sa obțineți pretul unui activ al carui nume este specificat.Tratați toate excepțiile ce pot fi generate.

CREATE OR REPLACE FUNCTION GET_PRET_ACTIV (
    V_NUME ACTIV.NUME%TYPE DEFAULT 'EGLD'
) RETURN NUMBER IS
    V_PRET ACTIV.PRET%TYPE;
BEGIN
    SELECT
        PRET INTO V_PRET
    FROM
        ACTIV
    WHERE
        NUME = V_NUME;
 --    DBMS_OUTPUT.PUT_LINE('Price of '
 --                         || V_NUME
 --                         || ' is '
 --                         || PRICE);
    RETURN V_PRET;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista active cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe active cu numele dat');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!');
END;
/

-- Default EGLD
SELECT
    GET_PRICE_ACTIV
FROM
    DUAL;

-- 2
SELECT
    GET_PRICE_ACTIV('DOGECOIN')
FROM
    DUAL;

-- NO_DATA_FOUND
SELECT
    GET_PRICE_ACTIV('SOLANA')
FROM
    DUAL;

-- TOO_MANY_ROWS
SELECT
    GET_PRICE_ACTIV('ETH')
FROM
    DUAL;

-- Exercitiul 4: model de rezolvare
CREATE OR REPLACE PROCEDURE P4_IST (
    V_NUME EMPLOYEES.LAST_NAME%TYPE
) IS
    SALARIU EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT
        SALARY INTO SALARIU
    FROM
        EMPLOYEES
    WHERE
        LAST_NAME = V_NUME;
    DBMS_OUTPUT.PUT_LINE('Salariul este '
                         || SALARIU);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!');
END P4_IST;
/

-- metode apelare
-- 1. Bloc PLSQL
BEGIN
    P4_IST('Bell');
END;
/