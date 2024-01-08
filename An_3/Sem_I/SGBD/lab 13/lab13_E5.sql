-- E5.
-- Să se modifice numele unui departament al cărui cod este dat de la tastatură. Să se trateze cazul în care nu există acel departament. Tratarea excepţie se va face în secţiunea executabilă.

SET SERVEROUTPUT ON;

DECLARE
    V_COD_DEPARTAMENT        NUMBER;
    V_NUME_NOU               VARCHAR2(50);
    E_DEPARTAMENT_INEXISTENT EXCEPTION;
BEGIN
    V_COD_DEPARTAMENT := &COD_DEPARTAMENT;
    V_NUME_NOU := '&nume_nou';
    UPDATE DEPARTMENTS
    SET
        DEPARTMENT_NAME = V_NUME_NOU
    WHERE
        DEPARTMENT_ID = V_COD_DEPARTAMENT;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE E_DEPARTAMENT_INEXISTENT;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Numele departamentului a fost actualizat.');
EXCEPTION
    WHEN E_DEPARTAMENT_INEXISTENT THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: Departamentul cu codul '
                             || V_COD_DEPARTAMENT
                             || ' nu există.');
END;
/