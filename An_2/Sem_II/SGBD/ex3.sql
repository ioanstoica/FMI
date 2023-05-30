-- 3. Pe un tabel dependent din schemă implementați cu ajutorul unui trigger o constrângere de integritate la alegere. Testați.
-- Observație: trebuie să apară explicit pe ce tabel și care este constrangerea implementată.

-- Pentru această cerință, am să creez un trigger pe tabela rental_ist care să verifice dacă un membru încearcă să închirieze mai mult de 3 titluri în aceeași zi. 

CREATE OR REPLACE TRIGGER check_rental_limit
BEFORE INSERT ON rental_ist
FOR EACH ROW
DECLARE
  v_rental_count NUMBER;
BEGIN
  -- Într-un bloc PL/SQL, selectăm numărul de închirieri ale aceluiași membru în aceeași zi.
  SELECT COUNT(*) INTO v_rental_count
  FROM rental_ist
  WHERE member_ist_id = :NEW.member_ist_id AND TRUNC(book_date) = TRUNC(SYSDATE);

  -- Dacă numărul închirierilor existente este deja 3, aruncăm o excepție.
  IF v_rental_count >= 3 THEN
    RAISE_APPLICATION_ERROR(-20000, 'Un membru nu poate închiria mai mult de 3 titluri în aceeași zi.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- Afișăm orice altă eroare care ar putea apărea.
    DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
END;
/

-- Primul închiriere pentru membrul 101 în aceeași zi
INSERT INTO rental_ist(book_date, copy_id, member_ist_id, title_ist_id)
VALUES (SYSDATE, 1, 101, 92);

-- A treia închiriere pentru membrul 101 în aceeași zi
INSERT INTO rental_ist(book_date, copy_id, member_ist_id, title_ist_id)
VALUES (SYSDATE, 1, 101, 97);

-- A patra închiriere pentru membrul 101 în aceeași zi (va declanșa eroarea)
INSERT INTO rental_ist(book_date, copy_id, member_ist_id, title_ist_id)
VALUES (SYSDATE, 1, 101, 96);

-- A 5-a închiriere pentru membrul 101 în aceeași zi (va declanșa eroarea)
INSERT INTO rental_ist(book_date, copy_id, member_ist_id, title_ist_id)
VALUES (SYSDATE, 2, 101, 95);

-- am executat toate comenziile, dar triggerul nu a fost declanșat
-- mesajul in console este:
SQL> INSERT INTO rental_ist(book_date, copy_id, member_ist_id, title_ist_id)
  2  VALUES (SYSDATE, 2, 101, 95);

1 row created.

Commit complete.