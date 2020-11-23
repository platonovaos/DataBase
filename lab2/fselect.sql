--Предикат сравнения
SELECT Tour.TourID, Tour.Cost
FROM Tour JOIN Food ON Tour.Food = Food.FoodID
WHERE Tour.Cost > 70000 AND Food.Bar = TRUE
ORDER BY Tour.TourID;

--Предикат BETWEEN
SELECT Hotel.Name, Tour.DateBegin, Tour.DateEnd
FROM Tour JOIN Hotel ON Tour.Hotel = Hotel.HotelID
WHERE DateBegin BETWEEN '2020-09-01' AND '2020-12-01'
ORDER BY Hotel.Name;

--Предикат LIKE
SELECT Food.Category, Tour.Cost
FROM Food RIGHT JOIN Tour ON Food.FoodID = Tour.Food
WHERE Category LIKE '%B%';

--Предикат IN с вложенным подзапросом
SELECT HotelID, Owner
FROM HC
WHERE CityID IN (
	SELECT City
	FROM Hotel
	WHERE Class < 2
)
ORDER BY HotelID;

--Предикат EXISTS с вложенным подзапросом
SELECT HotelID, Name
FROM Hotel
WHERE Cost < 5000 AND EXISTS (
	SELECT Hotel
	FROM Tour LEFT JOIN Food ON Tour.Food = Food.FoodID
	WHERE VegMENU = TRUE AND ChildrenMenu = TRUE AND Bar = TRUE
		AND Tour.Cost < 10000
);

--Предикат сравнения с квантором
SELECT HotelID, Name, Cost, Type
FROM Hotel
WHERE Cost > ALL (
	SELECT Cost
	FROM Hotel
	WHERE Class > 4 AND SwimPool = TRUE
);

--Агрегатные функции в выражениях столбцов
SELECT MIN(Food.Cost) AS FoodMin,
	MIN(Hotel.Cost) AS HotelMin
FROM Tour RIGHT JOIN Food
ON Tour.Food = Food.FoodID
LEFT JOIN Hotel
ON Hotel.HotelID = Tour.Hotel
WHERE (Tour.DateEnd - Tour.DateBegin) > 7;

--Скалярные подзапросы в выражениях столбцов
SELECT CityID, Name,
	(
		SELECT AVG(Cost)
		FROM Hotel
		WHERE Hotel.City = City.CityID
	) AS CostAvg,

	(
		SELECT MAX(Class)
		FROM Hotel
		WHERE Hotel.City = City.CityID
	) AS ClassMax
FROM City
WHERE CityID = 2;

--Простое выражение CASE
SELECT FoodID, Category, 
	CASE Bar
		WHEN True THEN '18+'
		WHEN FALSE THEN 
			CASE ChildrenMenu
				WHEN TRUE THEN '0+'
				WHEN FALSE THEN '14+'
			END
	END AS AgeLimit
FROM Food;
	
--Поисковое выражение CASE
SELECT TourID, Cost, 
	CASE
		WHEN (DateEnd - DateBegin) < 14 THEN 'Short'
		WHEN (DateEnd - DateBegin) < 28 THEN 'Middle'
		WHEN (DateEnd - DateBegin) < 61 THEN 'Long'
		ELSE 'Long Lasting'
	END AS Duration
FROM Tour;

--Создание новой временной локальной таблицы
DROP TABLE IF EXISTS TempLinksTable;

SELECT TourID AS Tour, HotelID AS Hotel, FoodID AS Food
INTO TempLinksTable
FROM Tour RIGHT JOIN Food
ON Tour.Food = Food.FoodID
LEFT JOIN Hotel
ON Hotel.HotelID = Tour.Hotel;

SELECT * FROM TempLinksTable;


--Вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM
SELECT TourID, City, Class
FROM Tour JOIN (
	SELECT HotelID, City, Class
	FROM Hotel
	WHERE Type = 'Mini'
	) AS HMainMini ON Tour.Hotel = HMainMini.HotelID
UNION
SELECT TourID, City, Class
FROM Tour JOIN (
	SELECT HotelID, City, Class
	FROM Hotel
	WHERE Type = 'Hostel'
	) AS HMainHostel ON Tour.Hotel = HMainHostel.HotelID
ORDER BY TourID;


--Вложенные подзапросы с уровнем вложенности 3
SELECT FoodID, Category, Cost as MaxFCost
FROM Food
GROUP BY FoodID
HAVING FoodID IN (
	SELECT Food 
	FROM Tour
	GROUP BY TourID
	HAVING Hotel IN (
		SELECT HotelID
		FROM Hotel
		WHERE Cost > (
			SELECT AVG(Cost) as AvgHCost
			FROM Hotel
			WHERE SwimPool = TRUE
		)
	)
);

--предложения GROUP BY, но без предложения HAVING
SELECT Class,
	AVG(Hotel.Cost) AS AvgCost,
	MAX(Hotel.Cost) AS MaxCost,
	MIN(Hotel.Cost) AS MinCost
FROM Tour RIGHT JOIN Food
ON Tour.Food = Food.FoodID
LEFT JOIN Hotel
ON Hotel.HotelID = Tour.Hotel
WHERE Food.Category LIKE '%B'
GROUP BY Class
ORDER BY Class;

--предложения GROUP BY и предложения HAVING
SELECT Class, AVG(Cost) AS AvgCost
FROM Hotel
GROUP BY Class
HAVING AVG(Cost) > (
	SELECT AVG(COST) AS ACost
	FROM HOTEL
)
ORDER BY Class;


--вставка в таблицу одной строки значений
INSERT INTO Food (FoodID, Category, VegMenu, ChildrenMenu, Bar, Cost)
VALUES (1500, 'BB', TRUE, TRUE, FALSE, 2340);

--вставка в таблицу результирующего набора данных вложенного подзапроса
INSERT INTO Hotel (HotelID, City, Name, Type, Class, SwimPool, Cost)
SELECT (
	SELECT COUNT(Hotel) + 1
	FROM Hotel), 

	City.CityID, 'New Spa Resort', 'Spa', 5, TRUE, 2410
FROM City
WHERE City.Name = 'Troy';

--Простая инструкция UPDATE
UPDATE Tour
SET DateEnd = DateEnd + 4
WHERE TourID = 27;

--UPDATE со скалярным подзапросом в предложении SET
UPDATE Tour
SET Cost = (
	SELECT AVG(Cost)
	FROM Tour
	)
WHERE TourID = 27;

--Простая инструкция DELETE
DELETE FROM Food
WHERE FoodID = 1500;

--DELETE с вложенным коррелированным подзапросом в предложении WHERE
DELETE FROM Hotel
WHERE HotelID = (
	SELECT COUNT(Hotel)
	FROM Hotel) AND 

	City IN (
		SELECT CityID
		FROM City
		WHERE Name = 'Troy'
);

--Инструкция SELECT, использующая простое обобщенное табличное выражение
WITH TempFood (Category, AvgPrice)
AS (
	SELECT Category, AVG(Cost)
	FROM Food
	WHERE VegMenu = TRUE
	GROUP BY Category
)
SELECT Category AS MostExpCategory
FROM TempFood
WHERE AvgPrice = (
	SELECT MAX(AvgPrice)
	FROM TempFood
);

--инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
WITH RECURSIVE TourCost(TourID, Cost, DateBegin, DateEnd)
AS (
	SELECT TourID, Cost, DateBegin, DateEnd FROM Tour
	WHERE TourID = 1
	
	UNION ALL
	
	SELECT (Tour.TourID + 1), Tour.Cost, Tour.DateBegin, Tour.DateEnd
	FROM Tour INNER JOIN TourCost
	ON Tour.TourID = TourCost.TourID
	WHERE Tour.TourID < 1000
)
SELECT * FROM TourCost;


--Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
SELECT Hotel.HotelID, Food.Category,
	AVG(Hotel.Cost) OVER (PARTITION BY Hotel.Class) AS AvgCostClass,
	AVG(Food.Cost) OVER (PARTITION BY Food.Category) AS AvgCostFood
FROM Tour RIGHT JOIN Food
ON Tour.Food = Food.FoodID
LEFT JOIN Hotel
ON Hotel.HotelID = Tour.Hotel
WHERE HotelID IS NOT NULL
ORDER BY HotelID;

--Оконные фнкции для устранения дублей
DROP TABLE IF EXISTS CityHotels;

SELECT City, Class, ROW_NUMBER() OVER(PARTITION by City, Class ORDER BY City) AS DupCount
INTO CityHotels
FROM Hotel;

DELETE FROM CityHotels
WHERE DupCount > 1;

ALTER TABLE CityHotels
DROP DupCount;

SELECT * FROM CityHotels;