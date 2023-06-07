-- Folosind cererea de mai jos in SQl Oracle, si tabele din baza de date de mai sus,
-- scrie intructinuile de insert necesare ca cererea de mai jos sa returneze cateva linii


WITH cte_last_update AS (
  SELECT Active.ID_activ, Active.Tip, Detineri.Cant, Detineri.Ult_actualizare
  FROM Active
  JOIN Detineri ON Active.ID_activ = Detineri.ID_detinere
)
SELECT Tip, SUM(Cant) AS Total_Cant
FROM cte_last_update
WHERE Ult_actualizare < TO_DATE('2023-01-01','YYYY-MM-DD')
GROUP BY Tip;
