-- Actualizează tipul tuturor activelor a căror preț este mai mare decât prețul mediu al tuturor activelor la 'Premium'
UPDATE Active SET Tip = 'Premium' 
WHERE Pret > (SELECT AVG(Pret) FROM Active);

-- Actualizează sediul tuturor brokerilor care au un comision de retragere mai mare decât media comisioanelor de retragere ale tuturor brokerilor la 'Expensive'
UPDATE Brokeri SET Sediu = 'Expensive' 
WHERE Comision_retragere > (SELECT AVG(Comision_retragere) FROM Brokeri);

-- Actualizează numărul maxim al criptomonedelor la 10000 dacă blockchain-ul asociat este de tipul 'Proof of Stake'
UPDATE Criptomonede SET Nr_maxim = 10000 
WHERE Blockchain IN (SELECT ID_blockchain FROM Blockchain WHERE Tip_of_proof = 'Proof of Stake');

-- Șterge toate tranzacțiile care au un volum mai mic decât volumul mediu al tuturor tranzacțiilor
DELETE FROM Tranzactii 
WHERE Volum < (SELECT AVG(Volum) FROM Tranzactii);

-- sterge toti brokeri cu comisionul de retragere mai mare cu 10% decat media comisioanelor de retragere
DELETE FROM Brokeri
WHERE Comision_retragere > (SELECT 1.1 * AVG(Comision_retragere) FROM Brokeri);

-- sterge toti brokeri cu Comision_tranzactie mai mare cu 50% decat media Comision_tranzactie
DELETE FROM Brokeri
WHERE Comision_tranzactie > (SELECT 1.5 * AVG(Comision_tranzactie) FROM Brokeri);




