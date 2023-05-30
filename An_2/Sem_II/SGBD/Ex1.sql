-- "Afișați lista tuturor categoriilor de titluri și numărul total de închirieri pentru fiecare categorie, pentru membrii care au efectuat cel puțin o închiriere într-o anumită lună și an. Parametrii de intrare vor fi luna și anul specificate. Pentru fiecare categorie de titluri, afișați numărul total de închirieri și lista membrilor care au efectuat închirieri în acea lună și an."

CREATE OR REPLACE PROCEDURE get_rentals_by_month(
  month IN NUMBER,
  year IN NUMBER
) AS
  -- selectez titlul categoriei, numarul de inchirieri si lista membrilor
  CURSOR c_rentals(month_val IN NUMBER, year_val IN NUMBER) IS
    SELECT 
        tit.category,
        COUNT(*) AS total_rentals,
        -- concatenez numele membrilor, luand doar valorile distincte
        LISTAGG(DISTINCT mem.last_name || ' ' || mem.first_name, ', ') WITHIN GROUP(
            ORDER BY
                mem.last_name,
                mem.first_name
        )
    AS members_list
    FROM RENTAL rnt
    JOIN MEMBER mem ON rnt.member_id = mem.member_id
    JOIN TITLE tit ON rnt.title_id = tit.title_id
    WHERE EXTRACT(MONTH FROM rnt.book_date) = month_val
      AND EXTRACT(YEAR FROM rnt.book_date) = year_val
    GROUP BY tit.category;
  
  v_category TITLE.category%TYPE;
  v_total_rentals NUMBER;
  v_members_list VARCHAR2(1000);
BEGIN
  OPEN c_rentals(month, year);
  LOOP
    FETCH c_rentals INTO v_category, v_total_rentals, v_members_list;
    EXIT WHEN c_rentals%NOTFOUND;
    
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


BEGIN
    get_rentals_by_month(
      5,
      2023
    );
END;