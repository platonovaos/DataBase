--Скалярная функция
--Средняя стоимость отелей заданного класса
DROP FUNCTION IF EXISTS avgCostHotels;
CREATE OR REPLACE FUNCTION avgCostHotels(classID int)
RETURNS NUMERIC
AS $$
	hotels = plpy.execute("SELECT Class, Cost FROM Hotel;")

	numHotels = 0
	cost = 0

	for hotel in hotels:
		if hotel['class'] == classid:
			cost += hotel['cost']
			numHotels += 1

	if numHotels > 0:
		return cost / numHotels
	return None
	
$$ LANGUAGE plpythonu;

SELECT * FROM avgCostHotels(0);
SELECT * FROM avgCostHotels(3);
SELECT * FROM avgCostHotels(5);


--Агрегатная функция
--a)Количество туров за указанный месяц
DROP FUNCTION IF EXISTS numToursPerMonth;
CREATE OR REPLACE FUNCTION numToursPerMonth(monthID int)
RETURNS INT
AS $$
	tours = plpy.execute("SELECT TourID, EXTRACT(MONTH FROM Tour.DateBegin) AS monthBegin, EXTRACT(MONTH FROM Tour.DateEnd) AS monthEnd FROM Tour;")
	numTours = 0
	
	for tour in tours:
		if tour['monthbegin'] == monthid and tour['monthend'] == monthid:
			numTours += 1;

	return numTours
$$ LANGUAGE plpythonu;

SELECT * FROM numToursPerMonth(1);
SELECT * FROM numToursPerMonth(6);
SELECT * FROM numToursPerMonth(12);


--б)Счетчик туров в указанные месяцы
DROP AGGREGATE IF EXISTS countTours(int);

DROP FUNCTION IF EXISTS countState;
CREATE FUNCTION countState(lastNum int, curid int) 
RETURNS int 
AS $$
	if curid == 0 or curid == None:
		return lastnum
		
	return lastnum + 1
	
$$ LANGUAGE plpythonu;


CREATE AGGREGATE countTours(int) 
(
    sfunc = countState,
    stype = int,
    initcond = 0
);

SELECT countTours(TourID)
FROM Tour
WHERE EXTRACT(MONTH FROM DateBegin) = 12 AND EXTRACT(MONTH FROM DateEnd) = 1;


--в)Средняя стоимость тура с указанной едой
DROP AGGREGATE IF EXISTS avgTourCost(int);

DROP FUNCTION IF EXISTS avgState;
CREATE FUNCTION avgState(lastCostNum numeric[2], curCost int) 
RETURNS numeric[2] 
AS $$
	if curcost == 0 or curcost == None:
		return lastCostNum
		
	return [lastcostnum[0] + curcost, lastcostnum[1] + 1]
	
$$ LANGUAGE plpythonu;

DROP FUNCTION IF EXISTS avgFinal;
CREATE FUNCTION avgFinal(costNum numeric[2]) 
RETURNS numeric
AS $$
	if costnum[1] == 0:
		return 0
		
	return costnum[0] / costnum[1]

$$ LANGUAGE plpythonu;


CREATE AGGREGATE avgTourCost(int) 
(
    sfunc = avgState,
    stype = numeric[],
    finalfunc = avgFinal,
    initcond = '{0,0}'
);

SELECT avgTourCost(Tour.Cost)
FROM Food JOIN Tour ON Food.FoodID = Tour.Food
WHERE Category = 'BB';



--Табличная функция
--Еда заданной категории, меню и баром
DROP FUNCTION IF EXISTS foodVar;
CREATE FUNCTION foodVar(catf varchar(30), vegf bool, childf bool, barf bool)
RETURNS SETOF Food
AS $$
	foods = plpy.execute("SELECT * FROM Food;")
	resfood = list()
	
	for food in foods:
		if food['category'] == catf and food['vegmenu'] == vegf and food['childrenmenu'] == childf and food['bar'] == barf:
			resfood.append(food)

	return resfood
$$ LANGUAGE plpythonu;

SELECT * FROM foodVar('BB', true, true, false);
SELECT * FROM foodVar('UAI', true, false, true);
SELECT * FROM foodVar('HB+', false, false, false);


--Хранимая процедура
--Увеличивает стоимость туров на новогодние праздники
DROP TABLE IF EXISTS TempTours;
SELECT *
INTO TEMP TempTours
FROM Tour;

DROP PROCEDURE IF EXISTS incPricesOnHolidays;
CREATE PROCEDURE incPricesOnHolidays(incCost int)
AS $$

	plan = plpy.prepare("UPDATE TempTours SET Cost = Cost + $1 WHERE EXTRACT (MONTH FROM DateBegin) = 12 AND EXTRACT (MONTH FROM DateEnd) = 1;", ["int"])
	plpy.execute(plan, [inccost])
	
$$ LANGUAGE plpythonu;

CALL incPricesOnHolidays(500);

SELECT * FROM TempTours
WHERE EXTRACT (MONTH FROM DateBegin) = 12 AND
	EXTRACT (MONTH FROM DateEnd) = 1;



--Триггер
--Вспомогательная таблица
DROP TABLE IF EXISTS TempHotels;
SELECT *
INTO TEMP TempHotels
FROM Hotel;

DROP TABLE IF EXISTS InfoTable;
CREATE TEMP TABLE InfoTable
(
	InfoID INT
);

--Триггер AFTER
DROP TRIGGER IF EXISTS insertTH ON TempHotels;

DROP FUNCTION IF EXISTS noticeInsert;
CREATE FUNCTION noticeInsert() 
RETURNS TRIGGER
AS $$

	plan = plpy.prepare("INSERT INTO InfoTable(InfoID) VALUES ($1);", ["int"])
	pi = TD['new']
	plpy.execute(plan, [pi["hotelid"]])
	
	plpy.notice("Insert done")

	return None
	
$$ LANGUAGE plpythonu;

CREATE TRIGGER insertTH AFTER INSERT ON TempHotels
FOR EACH ROW EXECUTE PROCEDURE noticeInsert();

INSERT INTO TempHotels(HotelID, City, Name, Type, Class, SwimPool, Cost)
VALUES (1001, 24, 'MoscowSpaCenter', 'Spa', 3, TRUE, 23190);

SELECT * FROM InfoTable;

SELECT * FROM TempHotels
ORDER BY HotelID DESC;



--Определяемый пользователем тип данных
--Туры длительностью, заданной пользователем
DROP TABLE IF EXISTS TTours;
DROP FUNCTION IF EXISTS getFullToursOnDuring;
DROP TYPE IF EXISTS FullTour;
CREATE TYPE FullTour AS 
(
	TourID int,
	City varchar,
	HotelName varchar, 
	FoodCategory varchar,
	During int,
	Cost int
);

CREATE FUNCTION getFullToursOnDuring(dur int)
RETURNS SETOF FullTour
AS $$

	restours = list()

	tours = plpy.execute("SELECT TourID, Hotel, Food, Cost, DateEnd - DateBegin as During FROM Tour;")
	hotels = plpy.execute("SELECT HotelID, Name as HotelName, City FROM Hotel;")
	foods = plpy.execute("SELECT FoodID, Category as FoodCategory FROM Food;")
	cities = plpy.execute("SELECT CityID, Name as City FROM City;")

	for tour in tours:
		if tour["during"] < dur:
			restour = tour.copy()
		
			for food in foods:
				if tour["food"] == food["foodid"]:
					restour.update(food)
				
			for hotel in hotels:
				if tour["hotel"] == hotel["hotelid"]:
					restour.update(hotel)

			for city in cities:
				if restour["city"] == city["cityid"]:
					restour.update(city)
					

			restours.append(restour)
	return restours
	
$$ LANGUAGE plpythonu;

SELECT * FROM getFullToursOnDuring(8);



--Защита
CREATE TEMP TABLE TTours
(
	TourID INT,
	TourDesc FullTour
);

INSERT INTO TTours(TourID, TourDesc) VALUES
	(1, (1, 'Moscow', 'MyHotel', 'UAI', 7, 35000)),
	(2, (10, 'Piter', 'MyHotel1', 'BB', 20, 42891)),
	(3, (7, 'Smolensk', 'MyHotel2', 'UAI', 31, 71250));

SELECT (TourDesc).HotelName, (TourDesc).FoodCategory
FROM TTours
WHERE (TourDesc).City = 'Moscow';











