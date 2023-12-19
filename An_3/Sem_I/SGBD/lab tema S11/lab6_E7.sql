-- E7.
-- Adaptați cerința exercițiului 4 pentru diagrama proiectului prezentată la materia Baze de Date din anul I. Rezolvați acest exercițiu în PL/SQL, folosind baza de date proprie.

-- a. Creați tabelul valoare_active cu următoarele coloane:
-- - id (cheie primară)
-- - tip_activ
-- - valoare

CREATE TABLE VALOARE_ACTIVE (
    ID INT PRIMARY KEY NOT NULL,
    TIP_ACTIV VARCHAR2(255),
    VALOARENUMBER(10, 4)
);

-- b. Introduceți date în tabelul creat anterior corespunzătoare informațiilor existente în schemă.

DECLARE
    CURSOR c_active IS
        SELECT Tip, SUM(Pret) AS SumaPret FROM Active GROUP BY Tip;
    v_id INT := 1;
    v_tip_activ VARCHAR2(255);
    v_valoare NUMBER(10, 4);
BEGIN
    FOR active_rec IN c_active LOOP
        v_tip_activ := active_rec.Tip;
        v_valoare := active_rec.SumaPret;

        INSERT INTO VALOARE_ACTIVE (ID, TIP_ACTIV, VALOARE)
        VALUES (v_id, v_tip_activ, v_valoare);
        
        v_id := v_id + 1; -- Incrementăm ID-ul pentru fiecare înregistrare
    END LOOP;
    
    COMMIT;
END;
/

-- c. Definiți un declanșator care va actualiza automat câmpul valoare atunci când se introduce un nou activ, respectiv se șterge un activ.

CREATE OR REPLACE TRIGGER TRG_VALOARE_ACTIVE
AFTER INSERT OR DELETE ON ACTIVE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE VALOARE_ACTIVE
        SET Valoare = Valoare + :NEW.Pret
        WHERE Tip_Activ = :NEW.Tip;
    ELSIF DELETING THEN
        UPDATE VALOARE_ACTIVE
        SET Valoare = Valoare - :OLD.Pret
        WHERE Tip_Activ = :OLD.Tip;
    END IF;
END;
/


-- declansare trigger insert
insert into active (id_activ, nume, tip, pret)
values (18, 'Rusia Bonds', 'Obligatiuni', 400);

select * from VALOARE_ACTIVE;

-- declansare trigger delete
delete from active where id_activ = 17;

select * from VALOARE_ACTIVE;