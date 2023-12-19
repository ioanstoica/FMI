-- E7.
-- Adaptați cerința exercițiului 5 pentru diagrama proiectului prezentată la materia Baze de Date din anul I. Rezolvați acest exercițiu în PL/SQL, folosind baza de date proprie.

-- Table: ETFuri
CREATE TABLE ETFURI (
    ID_ETF INT NOT NULL,
    EMITENT CHAR(20) NOT NULL,
    NUMAR_ACTIVE INT NOT NULL CHECK (NUMAR_ACTIVE>=10),
    PIATA_ACOPERITA CHAR(20) NOT NULL,
    CONSTRAINT ETFURI_PK PRIMARY KEY (ID_ETF)
);

SELECT
    *
FROM
    ETFURI;

-- exercitiul adaptat pentru diagrama proiectului din anul I
-- Sa se creeze un bloc PL/SQL care sa afiseze numarul de ETF-uri care au un numar de active mai mare decat o valoare data. Să se trateze cazul în care niciun ETF nu îndeplineşte această condiţie (excepţii externe).

SET SERVEROUTPUT ON

SET VERIFY OFF

ACCEPT p_val PROMPT 'Dati valoarea: '

DECLARE
    V_VAL    NUMBER := &P_VAL;
    V_NUMAR  NUMBER(7);
    EXCEPTIE EXCEPTION;
BEGIN
    SELECT
        COUNT(*) INTO V_NUMAR
    FROM
        ETFURI
    WHERE
        NUMAR_ACTIVE > V_VAL;
    IF V_NUMAR = 0 THEN
        RAISE EXCEPTIE;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Numarul de ETF-uri cu numar de active mai mare decat '
                             || V_VAL
                             || ' este '
                             || V_NUMAR);
    END IF;
EXCEPTION
    WHEN EXCEPTIE THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista ETF-uri pentru care sa se indeplineasca aceasta conditie');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Alta eroare');
END;
/

SET VERIFY ON

SET SERVEROUTPUT OFF