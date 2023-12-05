-- pachetul:
CREATE OR REPLACE PACKAGE PACHET_ACTIV AS
 -- Cursor pentru listarea tranzacÈ›iilor unui anumit activ
    CURSOR C_TRANZACTII(
        ID_ACTIV INT
    ) RETURN TRANZACTII%ROWTYPE;
 -- FuncÈ›ie pentru gÄ?sirea activului cel mai cumpÄ?rat
    FUNCTION F_ACTIV_MAXIM RETURN INT;
END PACHET_ACTIV;
/

CREATE OR REPLACE PACKAGE BODY PACHET_ACTIV AS
    CURSOR C_TRANZACTII(
        ID_ACTIV INT
    ) RETURN TRANZACTII%ROWTYPE IS
    SELECT
        *
    FROM
        TRANZACTII
    WHERE
        BUY = ID_ACTIV;

    FUNCTION F_ACTIV_MAXIM RETURN INT IS
        ID_MAX   INT;
        VAL_MAX  NUMBER := 0;
        TEMP_VAL NUMBER;
    BEGIN
        FOR R IN (
            SELECT
                BUY,
                SUM(PRET * VOLUM) AS TOTAL_VALOARE
            FROM
                TRANZACTII
            GROUP BY
                BUY
        ) LOOP
            IF R.TOTAL_VALOARE > VAL_MAX THEN
                VAL_MAX := R.TOTAL_VALOARE;
                ID_MAX := R.BUY;
            END IF;
        END LOOP;

        RETURN ID_MAX;
    END F_ACTIV_MAXIM;
END PACHET_ACTIV;
/

-- apelare
DECLARE
    ID_ACTIV_MAX  INT;
    TOTAL_VALOARE NUMBER;
BEGIN
    ID_ACTIV_MAX := PACHET_ACTIV.F_ACTIV_MAXIM;
    DBMS_OUTPUT.PUT_LINE('Activul cel mai cumparat: '
                         || ID_ACTIV_MAX);
    FOR V_CURSOR IN PACHET_ACTIV.C_TRANZACTII(ID_ACTIV_MAX) LOOP
        DBMS_OUTPUT.PUT_LINE('Tranzactie: '
                             || V_CURSOR.ID_TRANZACTIE
                             || ', Data: '
                             || V_CURSOR.DATA
                             || ', Pret: '
                             || V_CURSOR.PRET
                             || ', Volum: '
                             || V_CURSOR.VOLUM);
    END LOOP;
END;
/