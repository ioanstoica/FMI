-- sterge toti brokeri cu comisionul de retragere mai mare cu 10% decat media comisioanleor de retragere


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