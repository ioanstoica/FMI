-- Subqueries with at least three tables involved:

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
HAVING COUNT(*) > 5;

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


-- 5. Using at least 2 string functions, 2 date functions, and one CASE expression, along with a WITH clause:
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



WITH cte_last_update AS (
  SELECT Active.ID_activ, Active.Tip, Detineri.Cant, Detineri.Ult_actualizare
  FROM Active
  JOIN Detineri ON Active.ID_activ = Detineri.ID_detinere
)
SELECT Tip, SUM(Cant) AS Total_Cant
FROM cte_last_update
WHERE Ult_actualizare < TO_DATE('2023-01-01','YYYY-MM-DD')
GROUP BY Tip;
