--E7. Adaptati cerintele exercitiilor 2 si 4 (folosind ca baza cerintele exercitiilor 1, respectiv 3) pentru
--diagrama proiectului prezentata la materia Baze de Date din anul I. Rezolvati aceste doua exercitii
--in PL/SQL, folosind baza de date proprie.

-- Cerinta ex 1: Definiți un subprogram prin care sa obțineți pretul unui activ al carui nume este specificat.Tratați toate excepțiile ce pot fi generate.

-- 4. Rezolvați exercițiul 1 folosind o procedura stocata.

-- Procedura
CREATE OR REPLACE PROCEDURE GET_PRET_ACTIV_PROC (
    V_NUME IN ACTIV.NUME%TYPE,
    V_PRET OUT ACTIV.PRET%TYPE
) IS
BEGIN
    SELECT
        PRET INTO V_PRET
    FROM
        ACTIV
    WHERE
        NUME = V_NUME;
    DBMS_OUTPUT.PUT_LINE('Price of '
                         || V_NUME
                         || ' is '
                         || V_PRET);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista active cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe active cu numele dat');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!');
END GET_PRET_ACTIV_PROC;
/

-- apelare obisnuita
DECLARE
    PRET_ACTIV NUMBER;
BEGIN
    GET_PRET_ACTIV_PROC('EGLD', PRET_ACTIV);
    DBMS_OUTPUT.PUT_LINE('Pretul activului EGLD: '
                         || PRET_ACTIV);
END;
/

-- NO_DATA_FOUND ERROR
DECLARE
    PRET_ACTIV NUMBER;
BEGIN
    GET_PRET_ACTIV_PROC('SOLANA', PRET_ACTIV);
    DBMS_OUTPUT.PUT_LINE('Pretul activului SOLANA: '
                         || PRET_ACTIV);
END;
/

-- TOO_MANY_ROWS ERROR
DECLARE
    PRET_ACTIV NUMBER;
BEGIN
    GET_PRET_ACTIV_PROC('ETH', PRET_ACTIV);
    DBMS_OUTPUT.PUT_LINE('Pretul activului ETH: '
                         || PRET_ACTIV);
END;