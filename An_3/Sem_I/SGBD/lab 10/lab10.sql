-- lab 5
CREATE OR REPLACE PACKAGE PKG_EMP_IST AS

    FUNCTION GET_MIN_SALARY(
        P_DEPARTMENT_NAME IN DEPARTMENTS.DEPARTMENT_NAME%TYPE,
        P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE
    ) RETURN NUMBER;
 -- codul departamentului va fi obţinut cu ajutorul unei funcţii stocate în pachet, dându-se ca parametru numele acestuia;
    FUNCTION GET_DEPARTMENT_ID(
        P_DEPARTMENT_NAME IN DEPARTMENTS.DEPARTMENT_NAME%TYPE
    ) RETURN DEPARTMENTS.DEPARTMENT_ID%TYPE;
END;
/

-- package body
CREATE OR REPLACE PACKAGE BODY PKG_EMP_IST AS
 -- codul departamentului va fi obţinut cu ajutorul unei funcţii stocate în pachet, dându-se ca parametru numele acestuia;
    FUNCTION GET_DEPARTMENT_ID (
        P_DEPARTMENT_NAME IN DEPARTMENTS.DEPARTMENT_NAME%TYPE
    ) RETURN DEPARTMENTS.DEPARTMENT_ID%TYPE IS
        V_DEPARTMENT_ID DEPARTMENTS.DEPARTMENT_ID%TYPE;
    BEGIN
        SELECT
            DEPARTMENT_ID INTO V_DEPARTMENT_ID
        FROM
            DEPARTMENTS
        WHERE
            DEPARTMENT_NAME = P_DEPARTMENT_NAME;
        RETURN V_DEPARTMENT_ID;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare');
            RETURN -1;
    END;

    FUNCTION GET_MIN_SALARY(
        P_DEPARTMENT_NAME IN DEPARTMENTS.DEPARTMENT_NAME%TYPE,
        P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE
    ) RETURN NUMBER IS
        V_MIN_SALARY NUMBER;
    BEGIN
        SELECT
            MIN(SALARY) INTO V_MIN_SALARY
        FROM
            EMP_IST
        WHERE
            DEPARTMENT_ID = 10
            AND JOB_ID = 'IT_PROG';
        RETURN V_MIN_SALARY;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare');
            RETURN -1;
    END;
END;
/

SELECT
    PKG_EMP_IST.GET_MIN_SALARY('Administration', 'IT_PROG')
FROM
    DUAL;

/

SELECT
    PKG_EMP_IST.GET_DEPARTMENT_ID('IT')
FROM
    DUAL;


    