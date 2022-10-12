-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-06-20 01:51:21.084

-- foreign keys
ALTER TABLE Active
    DROP FOREIGN KEY Active_Actiuni;

ALTER TABLE Active
    DROP FOREIGN KEY Active_Criptomonede;

ALTER TABLE Active
    DROP FOREIGN KEY Active_Detineri;

ALTER TABLE Active
    DROP FOREIGN KEY Active_ETFuri;

ALTER TABLE Active
    DROP FOREIGN KEY Active_Obligatiuni;

ALTER TABLE Criptomonede
    DROP FOREIGN KEY Criptomonede_Blockchain;

ALTER TABLE Tranzactii
    DROP FOREIGN KEY Tranzactii_Active_Buy;

ALTER TABLE Tranzactii
    DROP FOREIGN KEY Tranzactii_Active_Sell;

ALTER TABLE Tranzactii
    DROP FOREIGN KEY Tranzactii_Brokeri;

-- tables
DROP TABLE Actiuni;

DROP TABLE Active;

DROP TABLE Blockchain;

DROP TABLE Brokeri;

DROP TABLE Criptomonede;

DROP TABLE Detineri;

DROP TABLE ETFuri;

DROP TABLE Obligatiuni;

DROP TABLE Tranzactii;

-- End of file.

