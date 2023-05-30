PROMPT EXERCITIUL 1

-- 1. Enunțați o cerere în limbaj natural care să implice în rezolvare utilizarea unui cursor cu parametru ce extrage informațiile din cel puțin 2 tabele și care utilizează cel puțin o funcție grup.
-- Scrieți un subprogram care utilizează acest cursor.
-- Vor fi returnate cel puțin două variabile.
-- Tratați erorile care pot să apară la apelare. Testați.

-- Cererea in limbaj natural:
-- "Afișați lista tuturor categoriilor de titluri
-- și numărul total de închirieri pentru fiecare categorie,
-- pentru membrii care au efectuat cel puțin o închiriere într-o anumită lună și an.
-- Parametrii de intrare vor fi luna și anul specificate.
-- Pentru fiecare categorie de titluri, afișați numărul total de închirieri
-- și lista membrilor care au efectuat închirieri în acea lună și an."


CREATE OR REPLACE PACKAGE CURSORS_PACKAGE IS
   TYPE RENTAL_CUR_TYPE IS
      REF CURSOR;
END CURSORS_PACKAGE;
/

CREATE OR REPLACE PROCEDURE AFISEAZAINCHIRIERI(
   LUNA IN NUMBER,
   AN IN NUMBER,
   REZULTAT1 OUT CURSORS_PACKAGE.RENTAL_CUR_TYPE,
   REZULTAT2 OUT CURSORS_PACKAGE.RENTAL_CUR_TYPE
) IS
   RENTAL_CUR       CURSORS_PACKAGE.RENTAL_CUR_TYPE;
   CATEGORIE        VARCHAR2(50);
   NUMAR_INCHIRIERI NUMBER;
   MEMBRU_ID        NUMBER;
BEGIN
   OPEN RENTAL_CUR FOR
      SELECT
         T.CATEGORY,
         COUNT(R.TITLE_IST_ID)
      FROM
         RENTAL_IST R
         INNER JOIN TITLE_IST T
         ON R.TITLE_IST_ID = T.TITLE_IST_ID
      WHERE
         EXTRACT(MONTH FROM R.BOOK_DATE) = LUNA
         AND EXTRACT(YEAR FROM R.BOOK_DATE) = AN
      GROUP BY
         T.CATEGORY;
   LOOP
      FETCH RENTAL_CUR INTO CATEGORIE, NUMAR_INCHIRIERI;
      EXIT WHEN RENTAL_CUR%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Categorie: '
         || CATEGORIE
         || ', Numar inchirieri: '
         || NUMAR_INCHIRIERI);
      OPEN REZULTAT1 FOR
         SELECT
            DISTINCT R.MEMBER_IST_ID
         FROM
            RENTAL_IST R
            INNER JOIN TITLE_IST T
            ON R.TITLE_IST_ID = T.TITLE_IST_ID
         WHERE
            T.CATEGORY = CATEGORIE
            AND EXTRACT(MONTH FROM R.BOOK_DATE) = LUNA
            AND EXTRACT(YEAR FROM R.BOOK_DATE) = AN;
      LOOP
         FETCH REZULTAT1 INTO MEMBRU_ID;
         EXIT WHEN REZULTAT1%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE('    Membru ID: '
            || MEMBRU_ID ); 
      END LOOP;
   END LOOP;
   CLOSE RENTAL_CUR;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('A aparut o eroare: '
         || SQLCODE
         || ' - '
         || SQLERRM);
END;
/

DECLARE
   REZULTAT1 CURSORS_PACKAGE.RENTAL_CUR_TYPE;
   REZULTAT2 CURSORS_PACKAGE.RENTAL_CUR_TYPE;
BEGIN
   AFISEAZAINCHIRIERI(5, 2023, REZULTAT1, REZULTAT2);
END;
/