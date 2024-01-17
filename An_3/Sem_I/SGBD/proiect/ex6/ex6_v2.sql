-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent care să utilizeze toate cele 3 tipuri de colecții studiate. Apelați subprogramul.

-- Se dă următoarea structură de tabele:
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

Scrie un subprogram care extrage intr-o colectie activele cumparate din lista de tranzactii, in alta colectie activele vandute, iar in alta colectie activele comune primelor 2 colectii. foloseste un subprogram stocat independent care să utilizeze toate cele 3 tipuri de colecții studiate  tablouri indexate (index-by tables), tablouri imbriate ( nested table) si vectori cu dimensiuni variabile (varrays). . Apelați subprogramul.