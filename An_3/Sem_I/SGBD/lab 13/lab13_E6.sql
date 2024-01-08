-- E6.
-- Să se creeze un bloc PL/SQL care afişează numele departamentului ce se află într-o anumită locaţie şi numele departamentului ce are un anumit cod (se vor folosi două comenzi SELECT). Să se trateze excepţia NO_DATA_FOUND şi să se afişeze care dintre comenzi a determinat eroarea. Să se rezolve problema în două moduri.

DECLARE
    V_DNAME  DEPT_IST.DEPARTMENT_NAME%TYPE;
    V_DNAME2 DEPT_IST.DEPARTMENT_NAME%TYPE;
    V_LOC    DEPT_IST.LOCATION_ID%TYPE;
    V_DEPTNO DEPT_IST.DEPARTMENT_ID%TYPE;
BEGIN
    SELECT
        DEPARTMENT_NAME INTO V_DNAME
    FROM
        DEPT_IST
    WHERE
        LOCATION_ID = 1700;
    SELECT
        DEPARTMENT_NAME INTO V_DNAME2
    FROM
        DEPT_IST
    WHERE
        DEPARTMENT_ID = 50;
    DBMS_OUTPUT.PUT_LINE(V_DNAME);
    DBMS_OUTPUT.PUT_LINE(V_DNAME2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF V_DNAME IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun departament cu locatia data');
        ELSIF V_DNAME2 IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun departament cu deptno 50');
        END IF;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('S-au gasit mai multe inregistrari');
END;
/