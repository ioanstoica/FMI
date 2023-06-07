-- Folosind cererea de mai jos in SQl Oracle, si tabele din baza de date de mai sus,
-- scrie intructinuile de insert necesare ca cererea de mai jos sa returneze cateva linii

WITH cte_last_update AS (
  SELECT Active.ID_activ, Active.Tip, Detineri.Cant, Detineri.Ult_actualizare
  FROM Active
  JOIN Detineri ON Active.ID_activ = Detineri.ID_detinere
)
SELECT Tip, SUM(Cant) AS Total_Cant
FROM cte_last_update
WHERE Ult_actualizare < TO_DATE('2023-01-01','YYYY-MM-DD')
GROUP BY Tip;

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

  

