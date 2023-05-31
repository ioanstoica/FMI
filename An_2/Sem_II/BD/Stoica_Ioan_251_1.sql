--Stoica Ioan, grupa 251, subiect 1

-- ex 1

SELECT
   TURIST.ID                            AS "Cod turist",
   TURIST.NUME || ' ' || TURIST.PRENUME AS "Nume si prenume",
   REZERVARE.ID                         "Cod rezervare",
   REZERVARE.DATA_REZERVARE             AS "Data rezervare",
   REZERVARE.NR_ZILE                    AS "Numar zile"
FROM
   TURIST_REZERVARE
   INNER JOIN TURIST
   ON TURIST_REZERVARE.ID_TURIST = TURIST.ID
   INNER JOIN REZERVARE
   ON TURIST_REZERVARE.ID_REZERVARE = REZERVARE.ID
ORDER BY
   REZERVARE.NR_ZILE;

-- nu mi-a mers partea de date

--select  turist.id  as "Cod turist", turist.nume || ' '  || turist.prenume as "Nume si prenume", rezervare.id "Cod rezervare", rezervare.data_rezervare as "Data rezervare", rezervare.nr_zile as "Numar zile"
--from turist_rezervare
--inner join turist
--on turist_rezervare.id_turist = turist.id
--inner join rezervare
--on turist_rezervare.id_rezervare = rezervare.id
--ORDER BY rezervare.nr_zile
--Where MONTH(rezervare.data_rezervare) =  'DEC' and DAY(rezervare.data_rezervare) + rezervare.nr_zile > 31
--;


-- ex 2
SELECT
   HOTEL.DENUMIRE,
   TURIST.LOCALITATE_DOMICILIU
FROM
   TURIST_REZERVARE
   INNER JOIN TURIST
   ON TURIST_REZERVARE.ID_TURIST = TURIST.ID
   INNER JOIN REZERVARE
   ON TURIST_REZERVARE.ID_REZERVARE = REZERVARE.ID
   INNER JOIN CAMERA
   ON REZERVARE.ID_CAMERA = CAMERA.ID
   INNER JOIN HOTEL
   ON CAMERA.ID_HOTEL = HOTEL.ID
WHERE
   TURIST.LOCALITATE_DOMICILIU = 'Bucuresti'
   OR TURIST.LOCALITATE_DOMICILIU = 'Iasi'
   OR TURIST.LOCALITATE_DOMICILIU = 'Timisoara';

-- select COUNT(*), turist.localitate_domiciliu from turist
-- GROUP BY turist.localitate_domiciliu;

SELECT
   HOTEL.DENUMIRE,
   COUNT(*) AS "Total rezervari"
FROM
   TURIST
   INNER JOIN TURIST_REZERVARE
   ON TURIST.ID = TURIST_REZERVARE.ID_TURIST
   INNER JOIN REZERVARE
   ON REZERVARE.ID = TURIST_REZERVARE.ID_REZERVARE
   INNER JOIN CAMERA
   ON CAMERA.ID = REZERVARE.ID_CAMERA
   INNER JOIN HOTEL
   ON HOTEL.ID = CAMERA.ID_HOTEL
GROUP BY
   HOTEL.DENUMIRE;

-- ex 3
-- obtin hotelul cele mai mutle rezervari
SELECT
   *
FROM
   (
      SELECT
         HOTEL.DENUMIRE,
         COUNT(*)TR
      FROM
         TURIST
         INNER JOIN TURIST_REZERVARE
         ON TURIST.ID = TURIST_REZERVARE.ID_TURIST
         INNER JOIN REZERVARE
         ON REZERVARE.ID = TURIST_REZERVARE.ID_REZERVARE
         INNER JOIN CAMERA
         ON CAMERA.ID = REZERVARE.ID_CAMERA
         INNER JOIN HOTEL
         ON HOTEL.ID = CAMERA.ID_HOTEL
      GROUP BY
         HOTEL.DENUMIRE
   ) TOT;

-- ex4
CREATE TABLE TARIF_MAXIM (
   NUME_HOTEL VARCHAR(256),
   NUMAR_CAMERA INT,
   COD_CAMERA INT,
   TARIF_MAXIM INT
);

SELECT
   *
FROM
   (
      SELECT
         MAX(TARIF_CAMERA.TARIF) AS "tar_maxim",
         TARIF_CAMERA.ID_CAMERA
      FROM
         TARIF_CAMERA
      GROUP BY
         TARIF_CAMERA.ID_CAMERA
   ) TAR
   INNER JOIN CAMERA
   ON TAR.ID_CAMERA = CAMERA.ID
   INNER JOIN HOTEL
   ON HOTEL.ID = CAMERA.ID_HOTEL;

-- ex 4 insert care nu functioneaza

-- INSERT INTO tarif_maxim
-- values
-- (
-- SELECT
--     hotel.denumire,
--     camera.nr_camera,
--     camera.id,
--    TAR.TM
-- FROM
--    (
--       SELECT
--          MAX(TARIF_CAMERA.TARIF) tm,
--          TARIF_CAMERA.ID_CAMERA
--       FROM
--          TARIF_CAMERA
--       GROUP BY
--          TARIF_CAMERA.ID_CAMERA
--    ) TAR
--    INNER JOIN CAMERA
--    ON TAR.ID_CAMERA = CAMERA.ID
--    INNER JOIN HOTEL
--    ON HOTEL.ID = CAMERA.ID_HOTEL
--    )sel;