-- Formuleaza o cerere in limbaj natural a carei rezolvare sa fie urmatorul cod:
SELECT
   A.NUME,
   DECODE(A.TIP,
   'Actiuni',
   'Stocks',
   'ETFuri',
   'ETF',
   'Crypto',
   'Criptomonede',
   'Unknown')   AS TYPE,
   NVL(B.NUME,
   'No Broker') AS BROKER
FROM
   ACTIVE A
   LEFT JOIN (
      SELECT
         BR.NUME,
         T.BUY
      FROM
         BROKERI    BR
         JOIN TRANZACTII T
         ON BR.ID_BROKER = T.BROKER
   ) B
   ON A.ID_ACTIV = B.BUY
ORDER BY
   A.NUME;

-- Formuleaza o cerere in limbaj natural a carei rezolvare sa fie urmatorul cod:
WITH T_INFO AS (
   SELECT
      T.ID_TRANZACTIE,
      T.DATA,
      UPPER(SUBSTR(BR.NUME,
      1,
      3))     AS BROKER,
      MONTHS_BETWEEN(SYSDATE,
      T.DATA) AS MONTHS_AGO
   FROM
      TRANZACTII T
      JOIN BROKERI BR
      ON T.BROKER = BR.ID_BROKER
)
SELECT
   TI.ID_TRANZACTIE,
   CASE
      WHEN TI.MONTHS_AGO < 6 THEN
         'Recent'
      ELSE
         'Old'
   END     AS TRANSACTION_AGE
FROM
   T_INFO     TI
WHERE
   LENGTH(TI.BROKER) > 1
ORDER BY
   TI.DATA DESC;
