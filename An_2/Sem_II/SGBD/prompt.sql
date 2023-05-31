-- se da urmatorul cod:

CREATE TABLE member_ist(
 member_ist_id    NUMBER (10) CONSTRAINT member_ist_id_pk PRIMARY KEY,
 last_name    VARCHAR2(25) CONSTRAINT member_ist_last_nn NOT NULL,
 first_name   VARCHAR2(25),
 address      VARCHAR2(100),
 city         VARCHAR2(30),
 phone        VARCHAR2(25),
 join_date    DATE DEFAULT SYSDATE CONSTRAINT join_date_nn NOT NULL)
;

CREATE TABLE title_ist(
 title_ist_id     NUMBER(10) CONSTRAINT title_ist_id_pk PRIMARY KEY,
 title  VARCHAR2(60) CONSTRAINT title_ist_nn NOT NULL,
 description  VARCHAR2(400) CONSTRAINT title_ist_desc_nn NOT NULL,
 rating       VARCHAR2(4)  CONSTRAINT title_ist_rating_ck 
   CHECK (rating IN ('G','PG','R','NC17','NR')),
 category     VARCHAR2(20) DEFAULT 'DRAMA' 
   CONSTRAINT title_ist_categ_ck 
   CHECK  (category IN ('DRAMA','COMEDY','ACTION','CHILD','SCIFI','DOCUMENTARY')),
 release_date DATE)
;

CREATE TABLE title_copy_ist(
 copy_id      NUMBER(10),
 title_ist_id     NUMBER(10)  CONSTRAINT copy_title_ist_id_fk REFERENCES title_ist(title_ist_id),
 status       VARCHAR2(15) CONSTRAINT copy_status_nn NOT NULL
   CONSTRAINT copy_status_ck 
   CHECK (status IN ('AVAILABLE','DESTROYED','RENTED','RESERVED')),
   CONSTRAINT copy_title_ist_id_pk  PRIMARY KEY(copy_id, title_ist_id))
;

CREATE TABLE rental_ist(
 book_date    DATE DEFAULT SYSDATE,
 copy_id      NUMBER(10),
 member_ist_id    NUMBER(10)   
   CONSTRAINT rental_ist_mbr_id_fk REFERENCES member_ist(member_ist_id),
 title_ist_id NUMBER(10),
 act_ret_date DATE,
 exp_ret_date DATE DEFAULT SYSDATE+2,
 CONSTRAINT rental_ist_copy_title_id_fk FOREIGN KEY (copy_id, title_ist_id)
     REFERENCES title_copy_ist(copy_id,title_ist_id), 
 CONSTRAINT rental_ist_id_pk PRIMARY KEY  (book_date, copy_id, title_ist_id, member_ist_id))
;

CREATE TABLE reservation_ist(
 res_date     DATE,
 member_ist_id    NUMBER(10) CONSTRAINT reservation_ist_mbr_id_fk REFERENCES member_ist(member_ist_id),
 title_ist_id     NUMBER(10) CONSTRAINT reservation_ist_title_ist_id_fk REFERENCES title_ist(title_ist_id),
 CONSTRAINT res_id_pk PRIMARY KEY  (res_date, member_ist_id, title_ist_id))
;

REATE VIEW title_avail_ist 
  AS
    SELECT t.title, c.copy_id, c.status, r.exp_ret_date
    FROM   title_ist t, title_copy_ist c, rental_ist r
    WHERE  t.title_ist_id = c.title_ist_id
    AND	   c.copy_id = r.copy_id (+)
    AND	   c.title_ist_id = r.title_ist_id (+);

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

-- codul de mai jos genereaza unele erori
-- vreau sa le repari

-- Trigger-ul verifica daca noua valoare a exp_ret_date este inainte de data curenta,
-- caz in care ii asigneaza chiar data curenta
-- Aceasta este a doua versiune de trigger, care nu declanseaza eroarea mutating table
-- Dupa executie putem vedea ca exp_ret_date devine data curenta
CREATE OR REPLACE TRIGGER rental_ret_date_trigger
  FOR INSERT OR UPDATE ON rental_ist
  COMPOUND TRIGGER
  
  TYPE r_rental_type IS RECORD (
    exp_ret_date rental_ist.exp_ret_date%TYPE,
    copy_id rental_ist.copy_id%TYPE,
    member_id rental_ist.member_id%TYPE,
    title_id rental_ist.title_id%TYPE
  );
  
  TYPE t_rentals_type IS TABLE OF r_rental_type INDEX BY PLS_INTEGER;
  
  t_rentals t_rentals_type;
  
  -- adaug inregistrarile afectate in tabelul t_rentals
  AFTER EACH ROW IS
  BEGIN
    t_rentals(t_rentals.COUNT + 1).exp_ret_date := :NEW.exp_ret_date;
    t_rentals(t_rentals.COUNT).copy_id := :NEW.copy_id;
    t_rentals(t_rentals.COUNT).member_id := :NEW.member_ist_id;
    t_rentals(t_rentals.COUNT).title_id := :NEW.title_ist_id;
  END AFTER EACH ROW;
  
  AFTER STATEMENT IS
    now_date rental_ist.exp_ret_date%TYPE;
  BEGIN
    now_date := SYSDATE;
  
    -- executam codul anterior, dar pentru fiecare inregistrare afectata
    FOR i IN 1..t_rentals.COUNT
    LOOP
      -- daca noua data de returnare este inaintea zilei de azi o schimbam cu data de astazi
      IF t_rentals(i).exp_ret_date < now_date
      THEN
        UPDATE rental_ist
        SET exp_ret_date = now_date
        WHERE 
          copy_id = t_rentals(i).copy_id AND 
          member_ist_id = t_rentals(i).member_id AND 
          title_ist_id = t_rentals(i).title_id;
      END IF;
    END LOOP;
  END AFTER STATEMENT;
END;

-- repara codul de mai sus
