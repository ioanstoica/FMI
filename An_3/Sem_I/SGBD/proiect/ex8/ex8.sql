-- 8. Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent de tip funcție care să utilizeze într-o singură comandă SQL 3 dintre tabelele definite. Definiți minim 2 excepții proprii. Apelați subprogramul astfel încât să evidențiați toate cazurile definite și tratate.

-- Enunt afiseaza Blockchain-ul pe care este listata criptomoneda cu cel mai mare pret in tabela Active.
CREATE OR REPLACE FUNCTION afiseaza_blockchain_criptomoneda_max
RETURN VARCHAR2 IS
    -- Definirea excepțiilor
    crypto_neexistent EXCEPTION;
    blockchain_neexistent EXCEPTION;

    -- Variabile
    id_criptomoneda_max INT;
    id_blockchain_max INT;
    nume_blockchain VARCHAR2(20);

BEGIN
    BEGIN
        -- Căutăm criptomoneda de tip 'Crypto' cu cel mai mare preț
        SELECT ID_activ INTO id_criptomoneda_max FROM Active
        WHERE Tip = 'Crypto'
        ORDER BY Pret DESC
        FETCH FIRST ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE crypto_neexistent;
    END;
    
    dbms_output.put_line('criptomoneda gasita: ' || id_criptomoneda_max);

    BEGIN 
        -- Căutăm blockchain-ul pe care este listată criptomoneda
        SELECT b.id_blockchain INTO id_blockchain_max
        FROM Criptomonede c
        JOIN Blockchain b ON c.blockchain = b.id_Blockchain
        WHERE c.id_criptomoneda = id_criptomoneda_max;
    
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE blockchain_neexistent;
    END;

    select a.nume into nume_blockchain
    from Blockchain a
    where a.id_blockchain = id_blockchain_max;
    -- Returnăm numele blockchain-ului
    RETURN nume_blockchain;

EXCEPTION
    WHEN crypto_neexistent THEN
        RETURN 'Nu există Active de tipul Crypto.';
    WHEN blockchain_neexistent THEN
        RETURN 'Criptomoneda găsită nu este listată pe niciun blockchain.';
    WHEN NO_DATA_FOUND THEN
        RETURN 'NO_DATA_FOUND';
    WHEN Others THEN
        RETURN 'A apărut o eroare neașteptată.';
END afiseaza_blockchain_criptomoneda_max;
/

SELECT afiseaza_blockchain_criptomoneda_max() FROM DUAL;

/

update active 
set nume =  'BTC', Tip = 'Crypto', Pret =  60000.00
where id_activ = 10;
/

SELECT afiseaza_blockchain_criptomoneda_max() FROM DUAL;
/

