-- Pentru a defini un trigger de tip LMD (Last Modified Date) la nivel de linie pentru tabela Detineri, vom crea un trigger care actualizează automat coloana Ult_actualizare la data și ora curentă de fiecare dată când o linie din tabel este modificată (de exemplu, atunci când este actualizată cantitatea).


CREATE OR REPLACE TRIGGER Detineri_LMD_Trigger
BEFORE UPDATE ON Detineri
FOR EACH ROW
BEGIN
    :NEW.Ult_actualizare := SYSDATE;
END;


UPDATE Detineri
SET Cant = 100
WHERE ID_detinere = 1;



