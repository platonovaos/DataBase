--Скалярная функция
--Средняя стоимость отелей указанного класса
DROP FUNCTION IF EXISTS avgCostHotels;
CREATE OR REPLACE FUNCTION avgCostHotels(classID int)
RETURNS NUMERIC
AS $$
	HClassCost = plpy.execute("SELECT Class, AVG(COST) AS avgCost FROM Hotel GROUP BY Class")
	for HClass in HClassCost:
		if HClass['class'] == classid:
			return HClass['avgcost']
	return -1
$$ LANGUAGE plpythonu;

SELECT * FROM avgCostHotels(0);
SELECT * FROM avgCostHotels(3);
SELECT * FROM avgCostHotels(5);


--Агрегатная функция
--Количество туров за указанный месяц
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


----Табличная функция
--
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
