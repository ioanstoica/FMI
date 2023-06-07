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


-- Reference: Tranzactii_Active_Buy (table: Tranzactii)
ALTER TABLE Tranzactii ADD CONSTRAINT Tranzactii_Active_Buy FOREIGN KEY (Buy)
    REFERENCES Active (ID_activ);

-- Reference: Tranzactii_Active_Sell (table: Tranzactii)
ALTER TABLE Tranzactii ADD CONSTRAINT Tranzactii_Active_Sell FOREIGN KEY (Sell)
    REFERENCES Active (ID_activ);

-- Reference: Tranzactii_Brokeri (table: Tranzactii)
ALTER TABLE Tranzactii ADD CONSTRAINT Tranzactii_Brokeri FOREIGN KEY (ID_tranzactie)
    REFERENCES Brokeri (ID_broker);

-- scrie 10 comenzi de insert pentru tabela Tranzactii