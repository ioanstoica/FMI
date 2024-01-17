-- 12.Definiți un trigger de tip LDD. Declanșați trigger-ul.

-- foloseste
-- Table: Detineri
CREATE TABLE Detineri (
    ID_detinere int NOT NULL,
    Cant int NOT NULL,
    Ult_actualizare date NOT NULL,
    CONSTRAINT Detineri_pk PRIMARY KEY (ID_detinere)
);