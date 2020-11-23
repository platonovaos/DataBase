--Хранимая процедура с/без параметров
DROP PROCEDURE IF EXISTS incPricesInBigCities;
CREATE PROCEDURE incPricesInBigCities(incCost int)
AS $$
	UPDATE Hotel
	SET Cost = Cost + incCost
	WHERE HotelID IN (
		SELECT HotelID FROM Hotel
		WHERE City IN (
			SELECT CityID FROM (
				SELECT CityID, COUNT(HotelID) AS NumHotels
				FROM HC
				GROUP BY CityID
				ORDER BY CityID
			) AS CNum
			WHERE NumHotels > 4
		)
	);
$$ LANGUAGE SQL;

CALL incPricesInBigCities(500);
CALL incPricesInBigCities(-500);

SELECT * FROM Hotel;
--Результат
SELECT HotelID, Cost FROM Hotel
WHERE City IN (
	SELECT CityID FROM (
		SELECT CityID, COUNT(HotelID) AS NumHotels
		FROM HC
		GROUP BY CityID
		ORDER BY CityID
	) AS CNum
	WHERE NumHotels > 4
)
ORDER BY HotelID;


--Рекурсивная хранимая процедура

--Создание временной таблицы
DROP TABLE IF EXISTS TF;

SELECT TourID, FoodID, Category, VegMenu, ChildrenMenu, Bar, Food.Cost, DateBegin, DateEnd 
INTO TEMP TF
FROM Food JOIN Tour ON Food.FoodID = Tour.Food;

ALTER TABLE TF ADD COLUMN FeastMenu BOOL;
ALTER TABLE TF ALTER COLUMN FeastMenu SET DEFAULT FALSE;

--Процедура
DROP PROCEDURE IF EXISTS addFeastMenu;
CREATE PROCEDURE addFeastMenu(dBegin date, dEnd date)
AS $$
BEGIN
	IF (dBegin < dEnd) THEN
		UPDATE TF
		SET FeastMenu = TRUE
		WHERE (DateBegin >= dBegin AND DateEnd <= dEnd);
		CALL addFeastMenu(dBegin + 1, dEnd);
	END IF;
END;
$$ LANGUAGE PLpgSQL;

--Результат
CALL addFeastMenu('2020-12-01', '2021-01-31');
CALL addFeastMenu('2020-05-01', '2020-06-30');

SELECT * FROM TF
ORDER BY FeastMenu;


--Хранимая процедура с курсором
DROP PROCEDURE IF EXISTS incPricesInFeasts;
CREATE OR REPLACE PROCEDURE incPricesInFeasts(incCost int)
AS $$
DECLARE foodCurs CURSOR FOR 
		SELECT * FROM TF
		WHERE FeastMenu = TRUE;
	curRow RECORD;
BEGIN
	OPEN foodCurs;
	LOOP
		FETCH foodCurs INTO curRow;
		EXIT WHEN NOT FOUND;
		
		UPDATE TF
		SET Cost = Cost + incCost
		WHERE TF.FoodID = curRow.FoodID;
	END LOOP;
	CLOSE foodCurs;
END;
$$ LANGUAGE PLpgSQL;

CALL incPricesInFeasts(950);
CALL incPricesInFeasts(-950);
	
SELECT * FROM TF
ORDER BY FeastMenu;


--Хранимая процедура доступа к метаданным
DROP TABLE IF EXISTS infoTbl;
CREATE TABLE InfoTbl (
    NameTbl VARCHAR(30) PRIMARY KEY,
    Size INT
);

DROP PROCEDURE IF EXISTS getTableSizes;
CREATE PROCEDURE getTableSizes()
AS $$
DECLARE curRow RECORD;
	tblCurs CURSOR FOR
		SELECT table_name, pg_table_size(cast(table_name AS VARCHAR)) as size
		FROM information_schema.tables
		WHERE table_schema = 'public'
		ORDER BY Size DESC;
BEGIN
	OPEN tblCurs;
	LOOP
		FETCH tblCurs INTO curRow;
		EXIT WHEN NOT FOUND;

		INSERT INTO InfoTbl (NameTbl, Size) 
		VALUES (curRow.table_name, curRow.size);
    
	END LOOP;
	CLOSE tblCurs;
END;
$$ LANGUAGE PLpgSQL;

CALL getTableSizes();
SELECT * FROM InfoTbl;


--Удаление таблицы с заданным размером
DROP TABLE IF EXISTS MyTableT;
CREATE TABLE MyTableT (
	ID int, 
	Value int
);

INSERT INTO MyTableT VALUES 
	(1, 34), (2, 25), (3, 58), (4, 24);

DROP PROCEDURE IF EXISTS removeTbl;
CREATE PROCEDURE removeTbl(s int)
AS $$
DECLARE n VARCHAR (30);
	curRow RECORD;
	tblCurs CURSOR FOR
		SELECT table_name, pg_table_size(cast(table_name AS VARCHAR)) as size
		FROM information_schema.tables
		WHERE table_schema = 'public';
		
BEGIN
	OPEN tblCurs;
	LOOP
		FETCH tblCurs INTO curRow;
		EXIT WHEN NOT FOUND;

		IF curRow.size < s THEN
			EXECUTE 'DROP TABLE ' || curRow.table_name;
		END IF;		
	END LOOP;
	CLOSE tblCurs;
END;
$$ LANGUAGE PLpgSQL;


CALL removeTbl(9000);

SELECT * FROM MyTableT;
