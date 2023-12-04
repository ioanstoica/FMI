-- E7. Adaptați cerințele exercițiilor 2 și 4 (folosind ca baz�? cerințele exercițiilor 1, respectiv 3) pentru diagrama proiectului prezentat�? la materia Baze de Date din anul I. Rezolvați aceste dou�? exerciții în PL/SQL, folosind baza de date proprie.

-- Cerinta: 1. Definiți un subprogram prin care s�? obțineți pretul unui activ al c�?rui nume este specificat.Tratați toate excepțiile ce pot fi generate.

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