-- Trigger-ul verifica daca noua valoare a exp_ret_date este inainte de data curenta,
-- caz in care ii asigneaza chiar data curenta
-- Aceasta este prima versiune de trigger, care declanseaza eroarea mutating table
CREATE OR REPLACE TRIGGER rental_ret_date_trigger
  AFTER INSERT OR UPDATE
  ON rental_ist
  FOR EACH ROW
DECLARE
  now_date rental_ist.exp_ret_date%TYPE;
BEGIN
  now_date := SYSDATE;
  
  -- daca noua data de returnare este inaintea zilei de azi o schimbam cu data de astazi
  IF :NEW.exp_ret_date < now_date
  THEN
    UPDATE rental_ist
    SET exp_ret_date = now_date
    WHERE copy_id = :NEW.copy_id AND member_id = :NEW.member_id AND title_id = :NEW.title_id;
  END IF;
END;

-- Functia de UPDATE va declansa eroarea mutating table
UPDATE rental_ist
SET exp_ret_date = TO_DATE('01.01.2000', 'DD.MM.YYYY')
WHERE copy_id = 2 AND member_ist_id = 101 AND title_ist_id = 93;

-- Trigger-ul verifica daca noua valoare a exp_ret_date este inainte de data curenta,
-- caz in care ii asigneaza chiar data curenta
-- Aceasta este a doua versiune de trigger, care nu declanseaza eroarea mutating table
-- Dupa executie putem vedea ca exp_ret_date devine data curenta
CREATE OR REPLACE TRIGGER rental_ret_date_trigger
  FOR INSERT OR UPDATE ON rental_ist
  COMPOUND TRIGGER

  -- corrected record type: member_id changed to member_ist_id and title_id to title_ist_id
  TYPE r_rental_type IS RECORD (
    exp_ret_date rental_ist.exp_ret_date%TYPE,
    copy_id rental_ist.copy_id%TYPE,
    member_ist_id rental_ist.member_ist_id%TYPE,
    title_ist_id rental_ist.title_ist_id%TYPE
  );

  TYPE t_rentals_type IS TABLE OF r_rental_type INDEX BY PLS_INTEGER;

  t_rentals t_rentals_type;

  -- changed member_id to member_ist_id and title_id to title_ist_id
  AFTER EACH ROW IS
  BEGIN
    t_rentals(t_rentals.COUNT + 1).exp_ret_date := :NEW.exp_ret_date;
    t_rentals(t_rentals.COUNT).copy_id := :NEW.copy_id;
    t_rentals(t_rentals.COUNT).member_ist_id := :NEW.member_ist_id;
    t_rentals(t_rentals.COUNT).title_ist_id := :NEW.title_ist_id;
  END AFTER EACH ROW;

  AFTER STATEMENT IS
    now_date DATE;  -- changed type to DATE
  BEGIN
    now_date := SYSDATE;

    -- execute the previous code, but for each affected record
    FOR i IN 1..t_rentals.COUNT
    LOOP
      -- if the new return date is before today, change it to today
      IF t_rentals(i).exp_ret_date < now_date
      THEN
        UPDATE rental_ist
        SET exp_ret_date = now_date
        WHERE 
          copy_id = t_rentals(i).copy_id AND 
          member_ist_id = t_rentals(i).member_ist_id AND 
          title_ist_id = t_rentals(i).title_ist_id;
      END IF;
    END LOOP;
  END AFTER STATEMENT;
END;
/
