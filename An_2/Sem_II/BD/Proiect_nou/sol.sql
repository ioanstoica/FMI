-- 1. subcereri sincronizate in care intervin cel putin 3 tabele
-- CERINTA: Am nevoie să obțin o listă cu numele și tipul activelor tranzacționate prin intermediul brokerilor care dețin mai mult de 200 de active. În această listă, vreau să fie inclus și numele brokerului prin intermediul căruia s-a realizat fiecare tranzacție 

SELECT
   A.NUME,
   A.TIP,
   BR.NUME AS NUME_BROKER
FROM
   ACTIVE     A
   JOIN TRANZACTII T
   ON A.ID_ACTIV = T.BUY JOIN BROKERI BR
   ON T.BROKER = BR.ID_BROKER
WHERE
   BR.NR_ACTIVE > 200;

-- 2. subcereri nesincronizate in clauza FROM
-- CERINTA: Doresc o listă cu numele și prețurile activelor de tip 'Acțiuni', ordonată descrescător după preț.
SELECT
   ACT.NUME,
   ACT.PRET
FROM
   (
      SELECT
         A.NUME,
         A.PRET
      FROM
         ACTIVE A
      WHERE
         A.TIP = 'Actiuni'
   ) ACT
ORDER BY
   ACT.PRET DESC;

-- 3.grupari  de  date  cu  subcereri  nesincronizate  in  care  intervin  cel  putin  3
-- tabele, functii grup, filtrare la nivel de grupuri (in cadrul aceleiasi cereri)
-- CERINTA: Am nevoie de o listă cu numele brokerilor care au efectuat mai mult de o tranzacție cu active de tip 'Acțiuni'. În această listă, vreau să includ numărul total de tranzacții realizate de fiecare broker și prețul mediu al tranzacțiilor.
SELECT
   BR.NUME,
   COUNT(*)    AS NR_TRANZACTII,
   AVG(T.PRET) AS PRET_MEDIU
FROM
   BROKERI BR
   JOIN (
      SELECT
         T.BROKER,
         T.PRET
      FROM
         TRANZACTII T
      WHERE
         T.SELL IN (
            SELECT
               A.ID_ACTIV
            FROM
               ACTIVE     A
            WHERE
               A.TIP = 'Actiuni'
         )
   ) T
   ON BR.ID_BROKER = T.BROKER
GROUP BY
   BR.NUME
HAVING
   COUNT(*) > 1;

-- 4. ordonari  si  utilizarea  functiilor  NVL  si  DECODE  (in  cadrul  aceleiasi cereri) 
-- CERINTA: Aș dori o listă cu numele activelor și tipul lor, tradus în engleză. Pentru active de tip 'Actiuni', tipul ar trebui să fie 'Stocks'; pentru 'ETFuri', 'ETF'; iar pentru 'Crypto', 'Criptomonede'. Dacă tipul activului nu se încadrează în aceste categorii, ar trebui să fie clasificat ca 'Unknown'. De asemenea, aș dori să se afișeze numele brokerului care a tranzacționat fiecare activ; în cazul în care brokerul nu este cunoscut, trebuie să fie indicat cu 'No Broker'. Lista ar trebui să fie ordonată după numele activelor.
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

-- 5. utilizarea  a  cel  putin  2  functii  pe  siruri  de  caractere,  2  functii  pe  date 
-- calendaristice,  a cel putin unei expresii CASE
-- CERINTA: Aș dori să obțin o listă cu id-ul tranzacțiilor, împreună cu vechimea acestora. Numele brokerilor ar trebui să fie convertite la majuscule și să includă doar primele trei caractere. Vechimea tranzacțiilor ar trebui calculată în luni, începând de la data curentă. Dacă vechimea tranzacției este mai mică de 6 luni, aceasta ar trebui clasificată ca 'Recent'; în caz contrar, ca 'Old'. Lista ar trebui să includă doar tranzacțiile pentru care numele brokerilor au mai mult de un caracter și ar trebui să fie ordonată descrescător după data tranzacției
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