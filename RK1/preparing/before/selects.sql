--Получить все пары вида <ФИО туриста, Страна проживания>
SELECT FirstName, LastName, Country 
FROM Tourists JOIN Cities 
ON Tourists.CityID = Cities.CityID;

/*
(Tourists JOIN Cities)[FirstName, LastName, Country]

--
RANGE OF TX IS Tourists
RANGE OF CX IS Cities

(TX.FirstName, TX.LastName, CX.Country) 
	WHERE EXISTS CX (TX.CityID = CX.CityID);
*/


--Получить все пары вида <Достопримечательность, Город>
SELECT Sights.NAME, Cities.NAME
FROM Sights JOIN Cities
ON Sights.CityID = Cities.CityID;

/*
(Sights JOIN Cities)[SIGHTS[NAME], CITIES[NAME]]

--
RANGE OF SX IS Sights
RANGE OF CX IS Cities

(SX.Name, CX.Name) 
	WHERE EXISTS CX (SX.CityID = CX.CityID);
*/


--Получить список всех туристов из Германии
SELECT Tourists.FirstName, Tourists.LastName
FROM Tourists JOIN Cities
ON Tourists.CityID = Cities.CityID
WHERE Cities.Country = 'Германия';

/*
((Tourists JOIN Cities) WHERE Cities[Country] = 'Германия')[FirstName, LastName]

--
RANGE OF TX IS Tourists
RANGE OF CX IS Cities WHERE Cities.Country = 'Германия'

(TX.FirstName, TX.LastName) 
	WHERE EXISTS CX (CX.CityID = TX.CityID);
*/


--Получить все тройки вида <ФИО туриста, Страна, Дата посещения>
SELECT Tourists.FirstName, Tourists.LastName, Cities.Name, ST.Date
FROM Tourists JOIN ST ON Tourists.ID = ST.TouristID
	JOIN Sights ON ST.SightID = Sights.ID
	JOIN Cities ON Sights.CityID = Cities.CityID;


/*
(Sights JOIN Cities JOIN ST JOIN Tourists)[FirstName, LastName, Name, Date]

--
RANGE OF SX IS Sights
RANGE OF CX IS Cities
RANGE OF STX IS ST
RANGE OF TX IS Tourists

(TX.FirstName, TX.LastName, CX.Name, STX.Date) 
WHERE EXISTS STX (CTX.TouristID = TX.ID AND
	EXISTS SX (SX.ID = STX.SightID) AND
	EXISTS CX (CX.CityID = SX.CityID))
*/


--Получить список всех достопримечательностей, которые посетил Смирнов Николай
SELECT Sights.Name
FROM Tourists JOIN ST ON Tourists.ID = ST.TouristID
	JOIN Sights ON ST.SightID = Sights.ID
WHERE Tourists.FirstName = 'Иван' AND Tourists.LastName = 'Платонов';

/*
((Tourists JOIN ST JOIN Sights) WHERE FirstName = 'Иван' AND LastName = 'Платонов') [Name]

--
RANGE OF TX IS Tourists WHERE FirstName = 'Иван' AND LastName = 'Платонов'
RANGE OF STX IS ST
RANGE OF SX IS Sights

(SX.Name) WHERE EXISTS STX (STX.TouristsID = TX.ID AND 
		EXISTS SX (SX.ID = STX.SightID))
*/	


--Получить список всех туристов, посетивших какую-либо страну в период с 05-01-2016 по 07-08-2017
SELECT DISTINCT Tourists
FROM Cities C1 JOIN Sights ON C1.CityID = Sights.CityID
JOIN ST ON Sights.ID = ST.SightID
JOIN Tourists ON ST.TouristID = Tourists.ID
JOIN Cities C2 ON Tourists.CityID = C2.CityID
WHERE Date BETWEEN '2020-01-01' AND '2020-12-31' AND
	C1.Country <> C2.Country;

/*
((Cities JOIN Sights JOIN ST JOIN Tourists JOIN Cities) 
(WHERE Date BETWEEN '2020-01-01' AND '2020-12-31' AND
	Country1 <> Country2)) [ID]

--
RANGE OF CX IS Cities
RANGE OF CY IS Cities
RANFE OF SX IS Sights
RANGE OF STX IS ST WHERE Date BETWEEN '2020-01-01' AND '2020-12-31'
RANGE OF TX IS Tourists

(TX) (WHERE EXISTS CX (CX.CityID = SX.CityID AND
		EXISTS STX (STX.SightID = SX.ID) AND
		EXISTS TX (TX.ID = STX.TouristsID AND
		EXISTS CY (CY.CityID = TX.CityID)))
*/

--Получить список всех туристов из Москвы, не посетивших ни одной достопримечательности в Санкт-Петербурге
SELECT *
FROM Tourists JOIN Cities ON Tourists.CityID = Cities.CityID
WHERE Cities.Name = 'Будапешт' AND Tourists.ID <> ALL(

	SELECT Tourists.ID
	FROM Cities JOIN Sights ON Cities.CityID = Sights.CityID
			JOIN ST ON Sights.ID = ST.SightID
			JOIN Tourists ON ST.TouristID = Tourists.ID
	WHERE Cities.Name = 'Питер'
);

/*
(Tourists JOIN Cities) 
(WHERE Cities[Name] = 'Будапешт' AND Tourists[ID] <>
	(Cities JOIN Sights JOIN ST JOIN Tourists
	WHERE Cities[Name] = 'Питер')[ID])[ID]


--
RANGE OF TX IS Tourists
RANGE OF CX IS Cities WHERE Cities.Name = 'Будапешт'
RANGE OF CY IS Cities WHERE Cities.Name = 'Питер'
RANGE OF SX IS Sights
RANGE OF STX IS ST

(TX) WHERE EXISTS CX (CX.CityID = TX.CityID) AND TX.ID <>
	((TX.ID) WHERE EXISTS STX (STX.TouristsID = TX.ID AND
			EXISTS SX (SX.ID = STX.SightID AND 
			EXISTS CY (СY.CityID = SX.CityID))))
*/


--Получить список всех туристов, никогда не бывших в Турции
SELECT *
FROM Tourists JOIN Cities ON Tourists.CityID = Cities.CityID
WHERE Tourists.ID <> ALL(

	SELECT Tourists.ID
	FROM Cities JOIN Sights ON Cities.CityID = Sights.CityID
			JOIN ST ON Sights.ID = ST.SightID
			JOIN Tourists ON ST.TouristID = Tourists.ID
	WHERE Cities.Country = 'Германия'
);


--Получить список туристов, побывавших в Амстердаме
SELECT Tourists.ID
FROM Cities JOIN Sights ON Cities.CityID = Sights.CityID
		JOIN ST ON Sights.ID = ST.SightID
		JOIN Tourists ON ST.TouristID = Tourists.ID
WHERE Cities.Country = 'Германия';

/*
((Cities JOIN Sights JOIN ST JOIN Tourists) 
WHERE Cities[Country] = 'Германия')[ID];

--
RANGE OF CX IS Cities WHERE Cities.Country = 'Германия'
RANGE OF SX IS Sights
RANGE OF STX IS ST
RANGE OF TX IS Tourists

(TX.ID) WHERE EXISTS STX (STX.TouristID = TX.ID AND
		EXISTS SX (SX.ID = STX.SightID AND
		EXISTS CX (CX.CityID = SX.CityID)))
*/


--Получить список всех туристов из Москвы, посещавших достопримечательности только в своей стране
SELECT *
FROM Tourists JOIN Cities ON Tourists.CityID = Cities.CityID
WHERE Cities.Name = 'Будапешт' AND Tourists.ID <> ALL (
	SELECT Tourists.ID
	FROM Tourists JOIN ST ON Tourists.ID = ST.TouristID
		JOIN Sights ON Sights.ID = ST.SightID
		JOIN Cities ON Sights.CityID = Cities.CityID
	WHERE Cities.Country = 'Париж'
);

/*
((Tourists JOIN Cities) WHERE Cities[Name] = 'Будапешт' AND Tourists[ID] <> (
	(Tourists JOIN ST JOIN Sights JOIN Cities) WHERE Cities[Country] = 'Париж')[ID])[ID]

--
RANGE OF TX IS Tourists
RANGE OF CX IS Cities WHERE Cities.Name = 'Будапешт'
RANGE OF TY IS Tourists
RANGE OF STX IS ST
RANGE OF SX IS Sights
RANGE OF CY IS Cities WHERE Cities.Country = 'Париж'

(TX) WHERE EXISTS CX (CX.CityID = TX.CityID AND TX[ID] <> (
	(TY.ID) WHERE EXISTS STX (STX.TouristID = TX.ID AND
			EXISTS SX (SX.ID = STX.SightID AND
			EXISTS CY (CY.CityID = SX.CityID))))
)
*/


--Получить имена всех туристов, не посетивших ни одну достопримечательность
SELECT *
FROM Tourists
WHERE Tourists.ID <> ALL (
	SELECT TouristID
	FROM ST
);

/*
((Tourists) WHERE Tourists[ID] <> ST[TouristID])[ID]

--
RANGE OF TX IS Tourists
RANGE OF STX IS ST

(TX.ID) WHERE TX.ID <> STX.TouristID
*/














