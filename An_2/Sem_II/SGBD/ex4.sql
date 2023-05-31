PROMPT EXERCITIUL 4.

-- 4. Implementați un trigger de tip instead of. Testați.


CREATE OR REPLACE TRIGGER title_avail_insert_trigger
INSTEAD OF INSERT ON title_avail_ist
BEGIN
   FOR new_data IN (SELECT * FROM title_avail_ist)
   LOOP
      -- Verificăm dacă există o copie disponibilă pentru titlul inserat
      SELECT COUNT(*) INTO COPY_COUNT
      FROM TITLE_COPY_IST
      WHERE TITLE_IST_ID = new_data.title_ist_id
        AND STATUS = 'AVAILABLE';

      -- Verificăm rezultatul interogării
      IF COPY_COUNT > 0 THEN
         -- Se permite inserarea în vedere
         INSERT INTO rental_ist (book_date, copy_id, member_ist_id, title_ist_id, act_ret_date, exp_ret_date)
         VALUES (new_data.book_date, new_data.copy_id, new_data.member_ist_id, new_data.title_ist_id, new_data.act_ret_date, new_data.exp_ret_date);
      ELSE
         -- Nu există o copie disponibilă, generăm o excepție și anulăm inserarea
         RAISE_APPLICATION_ERROR(-20001, 'Nu există o copie disponibilă pentru titlul specificat.');
      END IF;
   END LOOP;
END;
/

SHOW ERRORS;
