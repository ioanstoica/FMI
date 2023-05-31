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
