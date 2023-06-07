
SELECT a.Nume, a.Tip, b.Nume AS Nume_Broker
FROM Active a
WHERE a.ID_activ IN (
    SELECT t.Buy
    FROM Tranzactii t
    WHERE t.Broker IN (
        SELECT br.ID_broker
        FROM Brokeri br
        WHERE br.Nr_active > 200
    ) 
);

SELECT a.Nume, a.Tip, br.Nume AS Nume_Broker
FROM Active a
JOIN Tranzactii t ON a.ID_activ = t.Buy
JOIN Brokeri br ON t.Broker = br.ID_broker
WHERE br.Nr_active > 200;


-- 2. Non-correlated subquery in the FROM clause:
SELECT act.Nume, act.Pret
FROM (
    SELECT a.Nume, a.Pret
    FROM Active a
    WHERE a.Tip = 'Actiuni'
) act
ORDER BY act.Pret DESC;

-- 3. Grouping with non-correlated subqueries with at least three tables involved, group functions, group filtering:
SELECT br.Nume, COUNT(*) as Nr_tranzactii, AVG(t.Pret) as Pret_mediu
FROM Brokeri br
JOIN (
    SELECT t.Broker, t.Pret
    FROM Tranzactii t
    WHERE t.Sell IN (
        SELECT a.ID_activ
        FROM Active a
        WHERE a.Tip = 'Actiuni'
    )
) t ON br.ID_broker = t.Broker
GROUP BY br.Nume
HAVING COUNT(*) > 1;

-- 4. Ordering and the use of NVL and DECODE functions:
SELECT a.Nume,
       DECODE(a.Tip, 'Actiuni', 'Stocks', 'ETFuri', 'ETF', 'Crypto', 'Criptomonede', 'Unknown') as Type,
       NVL(b.Nume, 'No Broker') as Broker
FROM Active a
LEFT JOIN (
    SELECT br.Nume, t.Buy
    FROM Brokeri br
    JOIN Tranzactii t ON br.ID_broker = t.Broker
) b ON a.ID_activ = b.Buy
ORDER BY a.Nume;


-- 5. utilizarea  a  cel  putin  2  functii  pe  siruri  de  caractere,  2  functii  pe  date 
-- calendaristice,  a cel putin unei expresii CASE
WITH t_info AS (
    SELECT t.ID_tranzactie, t.Data, UPPER(SUBSTR(br.Nume, 1, 3)) as Broker, MONTHS_BETWEEN(SYSDATE, t.Data) as Months_Ago
    FROM Tranzactii t
    JOIN Brokeri br ON t.Broker = br.ID_broker
)
SELECT ti.ID_tranzactie,
       CASE
           WHEN ti.Months_Ago < 6 THEN 'Recent'
           ELSE 'Old'
       END as Transaction_Age
FROM t_info ti
WHERE LENGTH(ti.Broker) > 1
ORDER BY ti.Data DESC;



INSERT INTO Active (ID_activ, Nume, Tip, Pret) VALUES (1, 'Active1', 'Tip1', 100.1234);
INSERT INTO Detineri (ID_detinere, Cant, Ult_actualizare) VALUES (1, 100, TO_DATE('2022-12-31','YYYY-MM-DD'));

INSERT INTO Active (ID_activ, Nume, Tip, Pret) VALUES (2, 'Active2', 'Tip2', 200.1234);
INSERT INTO Detineri (ID_detinere, Cant, Ult_actualizare) VALUES (2, 200, TO_DATE('2022-11-30','YYYY-MM-DD'));

INSERT INTO Active (ID_activ, Nume, Tip, Pret) VALUES (3, 'Active3', 'Tip1', 150.1234);
INSERT INTO Detineri (ID_detinere, Cant, Ult_actualizare) VALUES (3, 150, TO_DATE('2022-12-01','YYYY-MM-DD'));

WITH cte_last_update AS (
  SELECT Active.ID_activ, Active.Tip, Detineri.Cant, Detineri.Ult_actualizare
  FROM Active
  JOIN Detineri ON Active.ID_activ = Detineri.ID_detinere
)
SELECT Tip, SUM(Cant) AS Total_Cant
FROM cte_last_update
WHERE Ult_actualizare < TO_DATE('2023-01-01','YYYY-MM-DD')
GROUP BY Tip;


SELECT Active.ID_activ, Active.Tip, Detineri.Cant, Detineri.Ult_actualizare
  FROM Active
  JOIN Detineri ON Active.ID_activ = Detineri.ID_detinere;


-- Insert into Active
INSERT INTO Active VALUES (1, 'Apple Actiuni', 'Actiuni', 150.25);
INSERT INTO Active VALUES (2, 'Microsoft Actiuni', 'Actiuni', 210.35);
INSERT INTO Active VALUES (3, 'Google Actiuni', 'Actiuni', 1520.20);
INSERT INTO Active VALUES (4, 'Amazon Actiuni', 'Actiuni', 2000.10);
INSERT INTO Active VALUES (5, 'Tesla Actiuni', 'Actiuni', 180.50);
INSERT INTO Active VALUES (6, 'Netflix Actiuni', 'Actiuni', 550.00);
INSERT INTO Active VALUES (7, 'Facebook Actiuni', 'Actiuni', 300.00);
INSERT INTO Active VALUES (8, 'Oracle Actiuni', 'Actiuni', 70.00);
INSERT INTO Active VALUES (9, 'IBM Actiuni', 'Actiuni', 140.00);
INSERT INTO Active VALUES (10, 'Intel Actiuni', 'Actiuni', 60.00);

-- Drops tables
DROP TABLE Actiuni;

DROP TABLE Active;

DROP TABLE Blockchain;

DROP TABLE Brokeri;

DROP TABLE Criptomonede;

DROP TABLE Detineri;

DROP TABLE ETFuri;

DROP TABLE Obligatiuni;

DROP TABLE Tranzactii;

-- Create tables
-- Table: Actiuni
CREATE TABLE Actiuni (
    ID_actiune int NOT NULL,
    Companie char(20) NOT NULL,
    Bursa char(20) NOT NULL,
    Nr_total int NOT NULL,
    CONSTRAINT Actiuni_pk PRIMARY KEY (ID_actiune)
);

-- Table: Active
CREATE TABLE Active (
    ID_activ int NOT NULL,
    Nume char(20) NOT NULL,
    Tip char(20) NOT NULL,
    Pret number(10,4) NOT NULL,
    CONSTRAINT Active_pk PRIMARY KEY (ID_activ)
);

-- Table: Blockchain
CREATE TABLE Blockchain (
    ID_blockchain int NOT NULL,
    Nume char(20) NOT NULL,
    Tip_of_proof char(20) NOT NULL,
    Moneda char(20) NOT NULL,
    CONSTRAINT Blockchain_pk PRIMARY KEY (ID_blockchain)
);

-- Table: Brokeri
CREATE TABLE Brokeri (
    ID_broker int NOT NULL,
    Nume char(20) NOT NULL,
    Sediu char(40) NOT NULL,
    Autorizat number(1) NOT NULL,
    Comision_retragere number(2,2) NOT NULL CHECK (Comision_retragere<=0.05),
    Comision_tranzactie number(2,2) NOT NULL CHECK (Comision_tranzactie<=0.02),
    Nr_active int NOT NULL CHECK (Nr_active>=100),
    CONSTRAINT Brokeri_pk PRIMARY KEY (ID_broker)
);

-- Table: Criptomonede
CREATE TABLE Criptomonede (
    ID_criptomoneda int NOT NULL,
    Cheie int NOT NULL,
    Nr_maxim int NOT NULL,
    Blockchain int NOT NULL,
    CONSTRAINT Criptomonede_pk PRIMARY KEY (ID_criptomoneda)
);

-- Table: Detineri
CREATE TABLE Detineri (
    ID_detinere int NOT NULL,
    Cant int NOT NULL,
    Ult_actualizare date NOT NULL,
    CONSTRAINT Detineri_pk PRIMARY KEY (ID_detinere)
);

-- Table: ETFuri
CREATE TABLE ETFuri (
    ID_ETF int NOT NULL,
    Emitent char(20) NOT NULL,
    Numar_active int NOT NULL CHECK (Numar_active>=10),
    Piata_acoperita char(20) NOT NULL,
    CONSTRAINT ETFuri_pk PRIMARY KEY (ID_ETF)
);

-- Table: Obligatiuni
CREATE TABLE Obligatiuni (
    ID_obligatiune int NOT NULL,
    Emitent char(20) NOT NULL,
    Scandenta date NOT NULL,
    Cupon number(10,2) NOT NULL,
    CONSTRAINT Obligatiuni_pk PRIMARY KEY (ID_obligatiune)
);

-- Table: Tranzactii
CREATE TABLE Tranzactii (
    ID_tranzactie int NOT NULL,
    Data date NOT NULL,
    Sell int NOT NULL,
    Buy int NOT NULL,
    Pret number(10,4) NOT NULL,
    Volum number(10,4) NOT NULL,
    Broker int NOT NULL,
    Brokeri_ID_broker int NOT NULL,
    CONSTRAINT ID_tranzactie PRIMARY KEY (ID_tranzactie)
);

-- foreign keys
-- Reference: Active_Actiuni (table: Active)
ALTER TABLE Active ADD CONSTRAINT Active_Actiuni FOREIGN KEY (ID_activ)
    REFERENCES Actiuni (ID_actiune);


-- Reference: Active_Criptomonede (table: Active)
ALTER TABLE Active ADD CONSTRAINT Active_Criptomonede FOREIGN KEY (ID_activ)
    REFERENCES Criptomonede (ID_criptomoneda);

-- Reference: Active_Detineri (table: Active)
ALTER TABLE Active ADD CONSTRAINT Active_Detineri FOREIGN KEY (ID_activ)
    REFERENCES Detineri (ID_detinere);

-- Reference: Active_ETFuri (table: Active)
ALTER TABLE Active ADD CONSTRAINT Active_ETFuri FOREIGN KEY (ID_activ)
    REFERENCES ETFuri (ID_ETF);

-- Reference: Active_Obligatiuni (table: Active)
ALTER TABLE Active ADD CONSTRAINT Active_Obligatiuni FOREIGN KEY (ID_activ)
    REFERENCES Obligatiuni (ID_obligatiune);

-- Reference: Criptomonede_Blockchain (table: Criptomonede)
ALTER TABLE Criptomonede ADD CONSTRAINT Criptomonede_Blockchain FOREIGN KEY (Blockchain)
    REFERENCES Blockchain (ID_blockchain);

-- Reference: Tranzactii_Active_Buy (table: Tranzactii)
ALTER TABLE Tranzactii ADD CONSTRAINT Tranzactii_Active_Buy FOREIGN KEY (Buy)
    REFERENCES Active (ID_activ);

-- Reference: Tranzactii_Active_Sell (table: Tranzactii)
ALTER TABLE Tranzactii ADD CONSTRAINT Tranzactii_Active_Sell FOREIGN KEY (Sell)
    REFERENCES Active (ID_activ);

-- Reference: Tranzactii_Brokeri (table: Tranzactii)
ALTER TABLE Tranzactii ADD CONSTRAINT Tranzactii_Brokeri FOREIGN KEY (ID_tranzactie)
    REFERENCES Brokeri (ID_broker);

-- Insert into Actiuni
INSERT INTO Actiuni VALUES (1, 'Apple', 'NASDAQ', 100000);
INSERT INTO Actiuni VALUES (2, 'Microsoft', 'NASDAQ', 50000);
INSERT INTO Actiuni VALUES (3, 'Google', 'NASDAQ', 75000);
INSERT INTO Actiuni VALUES (4, 'Amazon', 'NASDAQ', 50000);
INSERT INTO Actiuni VALUES (5, 'Tesla', 'NASDAQ', 60000);
INSERT INTO Actiuni VALUES (6, 'Netflix', 'NASDAQ', 30000);
INSERT INTO Actiuni VALUES (7, 'Facebook', 'NASDAQ', 40000);
INSERT INTO Actiuni VALUES (8, 'Oracle', 'NASDAQ', 35000);
INSERT INTO Actiuni VALUES (9, 'IBM', 'NASDAQ', 50000);
INSERT INTO Actiuni VALUES (10, 'Intel', 'NASDAQ', 45000);

-- Insert into Obligatiuni
-- Datele de "Scadenta" sunt folosite ca exemplu
INSERT INTO Obligatiuni VALUES (1, 'Romania', TO_DATE('2028-01-01','YYYY-MM-DD'), 3.5);
INSERT INTO Obligatiuni VALUES (2, 'SUA', TO_DATE('2030-01-01','YYYY-MM-DD'), 2.1);
INSERT INTO Obligatiuni VALUES (3, 'Germania', TO_DATE('2027-01-01','YYYY-MM-DD'), 0.5);
INSERT INTO Obligatiuni VALUES (4, 'Franta', TO_DATE('2032-01-01','YYYY-MM-DD'), 1.0);
INSERT INTO Obligatiuni VALUES (5, 'Marea Britanie', TO_DATE('2029-01-01','YYYY-MM-DD'), 1.5);
INSERT INTO Obligatiuni VALUES (6, 'Japonia', TO_DATE('2031-01-01','YYYY-MM-DD'), 0.1);
INSERT INTO Obligatiuni VALUES (7, 'Australia', TO_DATE('2033-01-01','YYYY-MM-DD'), 2.0);
INSERT INTO Obligatiuni VALUES (8, 'Canada', TO_DATE('2026-01-01','YYYY-MM-DD'), 2.2);
INSERT INTO Obligatiuni VALUES (9, 'China', TO_DATE('2034-01-01','YYYY-MM-DD'), 3.0);
INSERT INTO Obligatiuni VALUES (10, 'Brazilia', TO_DATE('2027-01-01','YYYY-MM-DD'), 4.5);

-- Insert into ETFuri
INSERT INTO ETFuri VALUES (1, 'Vanguard', 500, 'Global');
INSERT INTO ETFuri VALUES (2, 'BlackRock', 350, 'SUA');
INSERT INTO ETFuri VALUES (3, 'State Street', 300, 'Europe');
INSERT INTO ETFuri VALUES (4, 'Fidelity', 400, 'Asia');
INSERT INTO ETFuri VALUES (5, 'Invesco', 450, 'SUA');
INSERT INTO ETFuri VALUES (6, 'Charles Schwab', 400, 'Global');
INSERT INTO ETFuri VALUES (7, 'Northern Trust', 350, 'Europe');
INSERT INTO ETFuri VALUES (8, 'Goldman Sachs', 300, 'Asia');
INSERT INTO ETFuri VALUES (9, 'UBS Group', 500, 'SUA');
INSERT INTO ETFuri VALUES (10, 'BNP Paribas', 450, 'Global');

-- Insert into Blockchain
INSERT INTO Blockchain VALUES (1, 'Bitcoin', 'Proof-of-Work', 'BTC');
INSERT INTO Blockchain VALUES (2, 'Ethereum', 'Proof-of-Stake', 'ETH');
INSERT INTO Blockchain VALUES (3, 'Cardano', 'Proof-of-Stake', 'ADA');
INSERT INTO Blockchain VALUES (4, 'Polkadot', 'Proof-of-Stake', 'DOT');
INSERT INTO Blockchain VALUES (5, 'Litecoin', 'Proof-of-Work', 'LTC');
INSERT INTO Blockchain VALUES (6, 'Chainlink', 'Proof-of-Stake', 'LINK');
INSERT INTO Blockchain VALUES (7, 'Ripple', 'Consensus', 'XRP');
INSERT INTO Blockchain VALUES (8, 'Stellar', 'Consensus', 'XLM');
INSERT INTO Blockchain VALUES (9, 'Dogecoin', 'Proof-of-Work', 'DOGE');
INSERT INTO Blockchain VALUES (10, 'Tron', 'Proof-of-Stake', 'TRX');

-- Insert into Criptomonede
INSERT INTO Criptomonede VALUES (1, 123456, 21000000, 1);
INSERT INTO Criptomonede VALUES (2, 234567, 105000000, 2);
INSERT INTO Criptomonede VALUES (3, 345678, 45000000000, 3);
INSERT INTO Criptomonede VALUES (4, 456789, 1050000000, 4);
INSERT INTO Criptomonede VALUES (5, 567890, 84000000, 5);
INSERT INTO Criptomonede VALUES (6, 678901, 1000000000, 6);
INSERT INTO Criptomonede VALUES (7, 789012, 100000000000, 7);
INSERT INTO Criptomonede VALUES (8, 890123, 50000000000, 8);
INSERT INTO Criptomonede VALUES (9, 901234, 130000000000, 9);
INSERT INTO Criptomonede VALUES (10, 123450, 99000000000, 10);

-- Insert into Brokeri
INSERT INTO Brokeri VALUES (1, 'eToro', 'New York', 1, 0.02, 0.01, 200);
INSERT INTO Brokeri VALUES (2, 'Interactive Brokers', 'Connecticut', 1, 0.02, 0.01, 250);
INSERT INTO Brokeri VALUES (3, 'Robinhood', 'California', 1, 0.01, 0.005, 300);
INSERT INTO Brokeri VALUES (4, 'Coinbase', 'California', 1, 0.03, 0.02, 150);
INSERT INTO Brokeri VALUES (5, 'Binance', 'Malta', 1, 0.01, 0.005, 500);
INSERT INTO Brokeri VALUES (6, 'Kraken', 'California', 1, 0.02, 0.01, 350);
INSERT INTO Brokeri VALUES (7, 'Bitstamp', 'Luxembourg', 1, 0.03, 0.02, 200);
INSERT INTO Brokeri VALUES (8, 'Gemini', 'New York', 1, 0.02, 0.01, 300);
INSERT INTO Brokeri VALUES (9, 'Revolut', 'London', 1, 0.01, 0.005, 250);
INSERT INTO Brokeri VALUES (10, 'TradeStation', 'Florida', 1, 0.03, 0.02, 200);


-- Insert into Detineri
-- Datele de "Ult_actualizare" sunt folosite ca exemplu
INSERT INTO Detineri VALUES (1, 50, TO_DATE('2023-01-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (2, 100, TO_DATE('2023-02-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (3, 200, TO_DATE('2023-03-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (4, 150, TO_DATE('2023-04-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (5, 250, TO_DATE('2023-05-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (6, 300, TO_DATE('2023-06-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (7, 350, TO_DATE('2023-07-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (8, 400, TO_DATE('2023-08-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (9, 450, TO_DATE('2023-09-01','YYYY-MM-DD'));
INSERT INTO Detineri VALUES (10, 500, TO_DATE('2023-10-01','YYYY-MM-DD'));

-- Insert into Active
INSERT INTO Active VALUES (1, 'Apple Actiuni', 'Actiuni', 150.25);
INSERT INTO Active VALUES (2, 'Microsoft Actiuni', 'Actiuni', 210.35);
INSERT INTO Active VALUES (3, 'Google Actiuni', 'Actiuni', 1520.20);
INSERT INTO Active VALUES (4, 'Amazon Actiuni', 'Actiuni', 2000.10);
INSERT INTO Active VALUES (5, 'Tesla Actiuni', 'Actiuni', 180.50);
INSERT INTO Active VALUES (6, 'Netflix Actiuni', 'Actiuni', 550.00);
INSERT INTO Active VALUES (7, 'Facebook Actiuni', 'Actiuni', 300.00);
INSERT INTO Active VALUES (8, 'Oracle Actiuni', 'Actiuni', 70.00);
INSERT INTO Active VALUES (9, 'IBM Actiuni', 'Actiuni', 140.00);
INSERT INTO Active VALUES (10, 'Intel Actiuni', 'Actiuni', 60.00);


INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (1, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 5, 10, 100.50, 10.25, 1, 1);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (2, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 8, 6, 95.25, 8.75, 2, 1);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (3, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 4, 9, 110.75, 12.50, 1, 2);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (4, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 7, 2, 80.60, 6.20, 3, 2);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (5, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 3, 1, 95.80, 9.80, 2, 3);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (6, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 10, 8, 120.40, 15.00, 3, 4);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (7,TO_DATE('2023-06-01', 'YYYY-MM-DD'), 6, 3, 85.90, 7.50, 1, 4);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (8, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 2, 5, 100.00, 11.80, 2, 5);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (9, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 9, 4, 115.25, 13.75, 3, 5);
INSERT INTO Tranzactii (ID_tranzactie, Data, Sell, Buy, Pret, Volum, Broker, Brokeri_ID_broker)
VALUES (10, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 1, 7, 90.75, 8.90, 1, 6);
