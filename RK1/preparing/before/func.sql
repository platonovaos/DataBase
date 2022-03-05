--Получить все пары вида <Название достопримечательности, количество посетивших ее туристов>
SELECT Sights.Name, COUNT(*)
FROM Sights JOIN ST ON Sights.ID = ST.SightID
GROUP BY Sights.Name;

/*
(SUMMARIZE (Sights JOIN ST) PER Sights{Name}
	ADD COUNT AS cntT)[Name, cntT]

--
RANGE OF SX IS Sights
RANGE OF STX IS ST

(SX.Name, COUNT(STX WHERE EXISTS SX (SX.ID = STX.SightID)))
*/

--Получить ФИО самого молодого туриста
SELECT FirstName, LastName, Age
FROM Tourists
WHERE Age = (
	SELECT MIN(Age)
	FROM Tourists
);

/*
((Tourists) WHERE Tourists[Age] = (SUMMARIZE Tourists PER Tourists{Age} ADD MIN AS cntA))[FirstName, LastName]

--
RANGE OF TX IS Tourists

(TX.FirstNAME, TX.LastName, MIN(TX.Age))
*/


--Получить максимальный возраст туриста из Испании
SELECT MAX(Age)
FROM Tourists JOIN Cities ON Tourists.CityID = Cities.CityID
WHERE Cities.Country = 'Россия';

/*
(SUMMARIZE ((Tourists JOIN Cities) WHERE Cities[Country] = 'Россия') PER Tourists{Age}
	ADD MAX AS cntRA)[cntRA]

--
RANGE OF TX IS Tourists
RANGE OF CX IS Cities

(MAX(TX.Age WHERE EXISTS CX (CX.CityID = TX.CityID)))
*/


--Получить количество туристов в возрасте до 30 лет
SELECT COUNT(*)
FROM Tourists
WHERE Age < 30;

/*
(SUMMARIZE (Tourists WHERE Age < 30 PER {Age} ADD COUNT AS cntA))[cntA]

--
RANGE OF TX IS Tourists

(COUNT(TX WHERE TX.Age < 30)) AS CountAge
*/

--Получить средний возраст туристов, посетивших Бранденбургские ворота
SELECT AVG(Age)
FROM Sights JOIN ST ON Sights.ID = ST.SightID
	JOIN Tourists ON ST.TouristID = Tourists.ID
WHERE Sights.Name = 'Площадь';

/*
(SUMMARIZE ((Sights JOIN ST JOIN Tourists) WHERE Name = 'Площадь') PER Tourists{Age}
	ADD AVG AS AvgAge)[AvgAge]

RANGE OF SX IS Sights WHERE Sights.Name = 'Площадь';
RANGE OF STX IS ST
RANGE OF TX IS Tourists

(AVG(TX.Age)) WHERE EXISTS STX (STX.TouristID = TX.ID AND
			EXISTS SX (SX.ID = STX.SightID))
*/


