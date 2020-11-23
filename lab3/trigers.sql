--Вспомогательная таблица
DROP VIEW IF EXISTS TFview;
DROP TABLE IF EXISTS TFood;

SELECT TourID, FoodID, Category, VegMenu, ChildrenMenu, Bar, Food.Cost, DateBegin, DateEnd 
INTO TEMP TFood
FROM Food JOIN Tour ON Food.FoodID = Tour.Food;

--Триггер AFTER
DROP TRIGGER IF EXISTS insertTF ON TFood;

DROP FUNCTION IF EXISTS noticeInsert;
CREATE FUNCTION noticeInsert() 
RETURNS TRIGGER
AS $$
BEGIN
	RAISE NOTICE 'Insert done: TourID = %, FoodID = %',
		NEW.TourID, NEW.FoodID;
	RETURN NEW;
END;
$$ LANGUAGE PLpgSQL;

CREATE TRIGGER insertTF AFTER INSERT ON TFood
FOR EACH ROW EXECUTE PROCEDURE noticeInsert();

INSERT INTO TFood (TourID, FoodID, Category, Vegmenu, ChildrenMenu, Bar, Cost, DateBegin, DateEnd)
VALUES (1001, 1001, 'BB', TRUE, FALSE, TRUE, 731, '2020-12-25', '2021-01-15');

SELECT * FROM TFood
WHERE TourID = 1001;


--Триггер INSTEAD OF
DROP TRIGGER IF EXISTS deleteTF on TFood;
DROP FUNCTION IF EXISTS noticeDelete;

ALTER TABLE TFood ADD COLUMN IsDeleted BOOL;
CREATE VIEW TFview AS
SELECT * FROM TFood;


CREATE FUNCTION noticeDelete() 
RETURNS TRIGGER
AS $$
BEGIN       
	UPDATE TFview 
	SET IsDeleted = TRUE
	WHERE TourID = OLD.TourID;
	RAISE NOTICE 'Delete done';
	RETURN OLD;
END;
$$ LANGUAGE PLpgSQL;


CREATE TRIGGER deleteTF
INSTEAD OF DELETE ON TFview
FOR EACH ROW EXECUTE PROCEDURE noticeDelete();


DELETE FROM TFview
WHERE TourID = 1001;

SELECT * FROM TFview
ORDER BY IsDeleted;