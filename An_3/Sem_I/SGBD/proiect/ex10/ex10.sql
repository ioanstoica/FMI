-- Definiți un declanșator care va actualiza automat câmpul valoare atunci când se introduce un nou activ, respectiv se șterge un activ.

CREATE OR REPLACE TRIGGER TRG_VALOARE_ACTIVE
AFTER INSERT OR DELETE ON ACTIVE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE VALOARE_ACTIVE
        SET Valoare = Valoare + :NEW.Pret
        WHERE Tip_Activ = :NEW.Tip;
        dbms_output.put_line('Valoare activ: ' || :OLD.Tip || ' a fost actualizata');
    ELSIF DELETING THEN
        UPDATE VALOARE_ACTIVE
        SET Valoare = Valoare - :OLD.Pret
        WHERE Tip_Activ = :OLD.Tip;
        dbms_output.put_line('Valoare activ: ' || :OLD.Tip || ' a fost actualizata');
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