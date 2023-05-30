PROMPT EXERCITIUL 2.

-- 2. Vom numi "tip3" un tip de date ce folosește în definirea lui un alt tip de date ("tip2"),
-- care la rândul lui utilizează un alt tip de date ("tip1").
-- Definiți un astfel de tip, indicați ce anume reprezintă și utilizați-l prin adăugarea unei coloane de acest tip
-- la unul dintre tabelele din schemă.
-- Cu ajutorul unui bloc anonim actualizați coloana adăugată cu informații relevante din schemă.


-- Prima parte a cerinței este să definim un "tip3" care utilizează un "tip2" în definirea sa, iar "tip2" utilizează un "tip1" în definirea sa. Acestea pot fi definite folosind tipuri obiect sau înregistrări în PL/SQL.
-- În acest exemplu, vom crea "tip1" ca un tip obiect address_type pentru a stoca adresa unui membru, "tip2" ca un member_type care utilizează address_type și include alte câmpuri specifice unui membru, și "tip3" ca rental_type care utilizează member_type și include și alte informații legate de închiriere.

-- Creare tip1
CREATE OR REPLACE TYPE ADDRESS_TYPE_IST AS
   OBJECT (
      STREET VARCHAR2(100),
      CITY VARCHAR2(30)
   );
/

-- Creare tip2
CREATE OR REPLACE TYPE MEMBER_TYPE_IST AS
   OBJECT (
      MEMBER_ID NUMBER(10),
      LAST_NAME VARCHAR2(25),
      FIRST_NAME VARCHAR2(25),
      ADDRESS ADDRESS_TYPE_IST
   );
/

-- Creare tip3
CREATE OR REPLACE TYPE RENTAL_TYPE_IST AS
   OBJECT (
      BOOK_DATE DATE,
      MEMBER_TYPE MEMBER_TYPE_IST,
      TITLE_ID NUMBER(10)
   );
/

-- Adăugarea coloanei în tabel
ALTER TABLE rental_ist ADD (
    rental_info_ist rental_type_ist
);

-- Actualizarea coloanei adăugate
DECLARE
    -- Variabile pentru a stoca datele pe care le vom utiliza pentru a construi obiectele noastre.
    v_address VARCHAR2(100);
    v_city VARCHAR2(30);
    v_member_id NUMBER(10);
    v_last_name VARCHAR2(25);
    v_first_name VARCHAR2(25);
    v_book_date DATE;
    v_title_id NUMBER(10);

    -- Variabile pentru obiectele noastre.
    v_address_obj ADDRESS_TYPE_IST;
    v_member_obj MEMBER_TYPE_IST;
    v_rental_obj RENTAL_TYPE_IST;
BEGIN
    FOR r IN (SELECT m.member_ist_id, m.last_name, m.first_name, m.address, m.city, r.book_date, r.title_ist_id 
              FROM member_ist m JOIN rental_ist r ON m.member_ist_id = r.member_ist_id)
    LOOP
        -- Creăm obiectele noastre.
        v_address_obj := ADDRESS_TYPE_IST(r.address, r.city);
        v_member_obj := MEMBER_TYPE_IST(r.member_ist_id, r.last_name, r.first_name, v_address_obj);
        v_rental_obj := RENTAL_TYPE_IST(r.book_date, v_member_obj, r.title_ist_id);

        -- Actualizăm coloana cu obiectul nostru.
        UPDATE rental_ist
        SET rental_info_ist = v_rental_obj
        WHERE book_date = r.book_date 
          AND member_ist_id = r.member_ist_id 
          AND title_ist_id = r.title_ist_id;
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Afișează orice eroare care se produce în timpul execuției.
        DBMS_OUTPUT.PUT_LINE('A apărut o eroare: ' || SQLERRM);
END;
/
