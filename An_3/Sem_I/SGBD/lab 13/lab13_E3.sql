-- E3.
-- Să se creeze un bloc PL/SQL care tratează eroarea apărută în cazul în care se modifică codul unui departament în care lucrează angajaţi.

CREATE OR REPLACE TRIGGER TRG_DEPARTAMENT_IST BEFORE
    UPDATE OF DEPARTMENT_ID ON DEPT_IST FOR EACH ROW
DECLARE
    V_NR_ANGAJATI NUMBER;
BEGIN
    SELECT
        COUNT(*) INTO V_NR_ANGAJATI
    FROM
        EMPLOYEES
    WHERE
        DEPARTMENT_ID = :OLD.DEPARTMENT_ID;
    IF V_NR_ANGAJATI > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nu se poate modifica codul departamentului '
                                        || :OLD.DEPARTMENT_ID
                                        || ' deoarece exista '
                                        || V_NR_ANGAJATI
                                        || ' angajati in acest departament.');
    END IF;
END;
/

UPDATE DEPT_IST
SET
    DEPARTMENT_ID = 101
WHERE
    DEPARTMENT_ID = 100;