

CREATE OR REPLACE PROCEDURE get_rentals_by_month(
  month IN NUMBER,
  year IN NUMBER
) AS
  CURSOR c_rentals(month_val IN NUMBER, year_val IN NUMBER) IS
    SELECT tit.category, COUNT(*) AS total_rentals, LISTAGG(mem.last_name || ', ' || mem.first_name, ', ') WITHIN GROUP (ORDER BY mem.last_name, mem.first_name) AS members_list
    FROM RENTAL rnt
    JOIN MEMBER mem ON rnt.member_id = mem.member_id
    JOIN TITLE tit ON rnt.title_id = tit.title_id
    WHERE EXTRACT(MONTH FROM rnt.book_date) = month_val
      AND EXTRACT(YEAR FROM rnt.book_date) = year_val
    GROUP BY tit.category;
  
  v_category TITLE.category%TYPE;
  v_total_rentals NUMBER;
  v_members_list VARCHAR2(4000);
BEGIN
  OPEN c_rentals(month, year);
  LOOP
    FETCH c_rentals INTO v_category, v_total_rentals, v_members_list;
    EXIT WHEN c_rentals%NOTFOUND;
    
    -- Procesează datele extrase aici (poți afișa variabilele sau efectua alte operații)
    -- ...
    DBMS_OUTPUT.PUT_LINE('Category: ' || v_category);
    DBMS_OUTPUT.PUT_LINE('Total Rentals: ' || v_total_rentals);
    DBMS_OUTPUT.PUT_LINE('Members: ' || v_members_list);
  END LOOP;
  
  CLOSE c_rentals;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No rentals found for the specified month and year.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;


Acest subprogram utilizează un cursor numit `c_rentals` cu doi parametri: `month` și `year`. Cursorul extrage informațiile din tabelele `RENTAL`, `MEMBER` și `TITLE`, filtrând în funcție de luna și anul specificate. Utilizează funcția de grupare `GROUP BY` pentru a grupa rezultatele în funcție de categoria titlului. De asemenea, utilizează funcția `LISTAGG` pentru a concatena numele membrilor într-o listă, separată prin virgulă, pentru fiecare categorie de titluri. În bucla `LOOP`, se preiau valorile extrase din cursor în variabilele corespunzătoare și se procesează în consecință. În cazul în care nu se găsesc închirieri pentru luna și anul specific

ate, se afișează un mesaj corespunzător.

Pentru a testa acest subprogram, puteți apela procedura `get_rentals_by_month` și puteți furniza o lună și un an ca argumente.