-- E2.Creați un declanșator prin care s�? nu se permit�? m�?rirea comisionului astfel încât s�? dep�?șeasc�? 50% din valoarea salariului.

SELECT
    *
FROM
    EMP_IST;
/

UPDATE EMP_IST set COMMISSION_PCT = 0.6 WHERE EMPLOYEE_ID = 7;
/

CREATE OR REPLACE TRIGGER trig_EMP_IST BEFORE
    UPDATE ON EMP_ist FOR EACH ROW
BEGIN
    IF :NEW.COMMISSION_PCT > 0.5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Comisionul nu poate fi mai mare de 50%');
    END IF;
END;
/

-- drop trigger EMP_IST;

drop trigger EMP_IST;
/