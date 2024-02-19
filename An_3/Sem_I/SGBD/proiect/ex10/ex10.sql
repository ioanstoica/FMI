-- Definiti un triger care sa nu permita modificarile in Detineri, intr-un interval orar

CREATE OR REPLACE TRIGGER trig_program
	BEFORE INSERT OR DELETE OR UPDATE ON Detineri
BEGIN
	IF (TO_CHAR(SYSDATE,'D') = 1)
		OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 12)
	THEN RAISE_APPLICATION_ERROR(-20001,'Operatiile asupra tabelului sunt permise
		doar in programul de lucru!');
	END IF;
END;
/

INSERT INTO Detineri VALUES (11, 500, TO_DATE('2024-02-19','YYYY-MM-DD'));

select * from Detineri;