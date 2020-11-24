--Скалярная функция
--Средняя стоимость отелей заданного класса
DROP FUNCTION IF EXISTS avgCostHotels;
CREATE OR REPLACE FUNCTION avgCostHotels(classID int)
RETURNS NUMERIC
AS $$
	HClassCost = plpy.execute("SELECT Class, AVG(COST) AS avgCost FROM Hotel GROUP BY Class;")
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


--Табличная функция
--Еда заданной категории, меню и баром
DROP FUNCTION IF EXISTS foodVar;
CREATE OR REPLACE FUNCTION foodVar(catf varchar(30), vegf bool, childf bool, barf bool)
RETURNS SETOF Food
AS $$
	foods = plpy.execute("SELECT * FROM Food;")
	resfood = list()
	
	for food in foods:
		if food['category'] == catf and food['vegmenu'] == vegf and food['childrenmenu'] == childf and food['bar'] == barf:
			resfood.append(food);

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

--Триггер AFTER
DROP TRIGGER IF EXISTS insertTH ON TempHotels;

DROP FUNCTION IF EXISTS noticeInsert;
CREATE FUNCTION noticeInsert() 
RETURNS TRIGGER
AS $$

	plpy.notice("Insert done")
	return TD['old']
	
$$ LANGUAGE plpythonu;

CREATE TRIGGER insertTF AFTER INSERT ON TempHotels
FOR EACH ROW EXECUTE PROCEDURE noticeInsert();

INSERT INTO TempHotels(HotelID, City, Name, Type, Class, SwimPool, Cost)
VALUES (1001, 24, 'MoscowSpaCenter', 'Spa', 3, TRUE, 23190);

SELECT * FROM TempHotels
ORDER BY HotelID DESC;



--Определяемый пользователем тип данных
create type plane; -- "(model, places)"

create or replace function plane_in(cstring) returns plane
as
'plane.so',
'plane_in'
    language C immutable
               strict;

create or replace function plane_out(plane) returns cstring
as
'$libdir/plane',
'plane_out'
    language C immutable
               strict;

drop type plane cascade;
create type plane (
    internallength = 34,
    input = plane_in,
    output = plane_out
    );

select '(Superjet, 2300)'::plane;













