-- E4.
-- Să se creeze un bloc PL/SQL prin care se afişează numele departamentului 10 dacă numărul său de angajaţi este într-un interval dat de la tastatură. Să se trateze cazul în care departamentul nu îndeplineşte această condiţie.

set serveroutput on;

DECLARE
    V_NR_ANGAJATI      NUMBER;
    V_NUME_DEPARTAMENT VARCHAR2(20);
BEGIN
    SELECT
        COUNT(*) INTO V_NR_ANGAJATI
    FROM
        EMPLOYEES
    WHERE
        DEPARTMENT_ID = 10;
    IF V_NR_ANGAJATI BETWEEN &NR1 AND &NR2 THEN
        SELECT
            DEPARTMENT_NAME INTO V_NUME_DEPARTAMENT
        FROM
            DEPARTMENTS
        WHERE
            DEPARTMENT_ID = 10;
        DBMS_OUTPUT.PUT_LINE('Numele departamentului 10 este: '
                             || V_NUME_DEPARTAMENT);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Departamentul 10 nu are numarul de angajati in intervalul dat.');
    END IF;
END;
/