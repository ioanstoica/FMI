DROP VIEW copies_view;

-- Creez un view compus din 2 tabele
CREATE VIEW copies_view AS
  SELECT
    tc.copy_id,
    t.title,
    t.description,
    t.category,
    tc.status
  FROM title_copy_ist tc
  LEFT JOIN title_ist t ON tc.title_ist_id = t.title_ist_id;
  
-- Inainte sa creez trigger-ul, o astfel de instructiune de INSERT va da eroare.
INSERT INTO copies_view (
  copy_id,
  title,
  description,
  category,
  status
)
VALUES (
  4,
  'Willie and Christmas Too',
  'All of Willie''s friends made a Christmas list for Santa, but Willie has yet 
   to create his own wish list.',
  'CHILD',
  'AVAILABLE'
);

DROP TRIGGER new_copy_trigger;

-- Creez un trigger care insereaza date doar in tabelul title_copy
CREATE OR REPLACE TRIGGER new_copy_trigger
  INSTEAD OF INSERT ON copies_view
  FOR EACH ROW
DECLARE
  title_ist_id title_ist.title_ist_id%TYPE;
BEGIN
  SELECT title_ist_id INTO title_ist_id FROM title_ist 
  WHERE title = :NEW.title AND description = :NEW.description AND category = :NEW.category;

  INSERT INTO title_copy_ist (copy_id, title_ist_id, status)
  VALUES (:NEW.copy_id, title_ist_id, :NEW.status);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No title found with this description and category!');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Unable to insert new title as there are multiple records with these description and category!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured: ' || SQLERRM);
END;