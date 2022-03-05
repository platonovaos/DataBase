--Скалярная функция
DROP FUNCTION IF EXISTS avgCostTopHotels;
CREATE FUNCTION avgCostTopHotels()
RETURNS NUMERIC
AS $$
	SELECT avgCost 
	FROM (
		SELECT Class, AVG(COST) AS avgCost
		FROM Hotel
		GROUP BY Class
	) AS CA
	WHERE Class = 5;
$$ LANGUAGE SQL;

SELECT * FROM avgCostTopHotels();


--Подставляемая табличная функция
DROP FUNCTION IF EXISTS healthCheapTour;

CREATE FUNCTION healthCheapTour(yearT int, classH int, childMenu bool)
RETURNS SETOF Tour
AS $$
BEGIN
	RETURN QUERY (
		SELECT TourID, Food, Hotel, Tour.Cost, DateBegin, DateEnd
		FROM Tour JOIN Hotel ON Tour.Hotel = Hotel.HotelID
		WHERE (DateBegin - DateEnd) = dur
	);
END;
$$ LANGUAGE PLpgSQL;

SELECT * FROM healthCheapTour(2021, 5, true);
SELECT * FROM healthCheapTour(2020, 0, false);


--Многооператорная табличная функция
/*DROP FUNCTION IF EXISTS costFoodParams;

CREATE FUNCTION costFoodParams(varchar(40), bool, bool, bool)
RETURNS TABLE(Id int, CatF varchar(40), CostF int)
AS $$
BEGIN
	DROP TABLE IF EXISTS TempFood;
	CREATE TEMP TABLE TempFood(Id int, CatF varchar(40), CostF int);
    
	INSERT INTO TempFood(Id, CatF, CostF) (
		SELECT FoodID, Category, Cost
		FROM Food
		WHERE Category = $1 AND VegMenu = $2 AND ChildrenMenu = $3 AND Bar = $4 AND Cost > (
			SELECT AVG(Cost)
			FROM Food
		)
	);

	RETURN QUERY
	SELECT * FROM TempFood;
END;
$$ LANGUAGE PLpgSQL;

SELECT * FROM costFoodParams('HB+', true, true, true);
SELECT * FROM costFoodParams('UAI', false, true, false);


--Рекурсивная функция
DROP FUNCTION IF EXISTS cityInRange;

CREATE FUNCTION cityInRange(rBegin int, rEnd int)
RETURNS SETOF City
AS $$
BEGIN
	RETURN QUERY 
	SELECT * FROM City
	WHERE CityID = rBegin;

	IF (rBegin < rEnd) THEN
		RETURN QUERY
		SELECT * FROM d(rBegin + 1, rEnd);
	END IF;
END;
$$ LANGUAGE PLpgSQL;

SELECT * FROM cityInRange(2, 10);
SELECT * FROM cityInRange(5, 30);
SELECT * FROM cityInRange(1, 3);
*/		