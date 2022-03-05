SELECT * FROM Drivers;
SELECT * FROM Fines;
SELECT * FROM Cars;
SELECT * FROM DC;

--1)Найти все пары вида <ФИО водителя, год его автомобиля>
--SQL
SELECT FIO, Year
FROM Drivers JOIN DC ON Drivers.DriverID = DC.DriverID
	JOIN Cars ON DC.CarID = Cars.CarID;

--РА
/*
(Drivers JOIN DC JOIN Cars)[FIO, Year]

--ИК
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS Cars

(DX.FIO, CX.Year) WHERE EXISTS DCX (DX.DriverID = DCX.DriverID AND
			EXISTS CX (DCX.CarID = CX.CarID))

*/


--2)Найти водителей, у которых нат машины красного цвета
--SQL
SELECT DriverID, FIO
FROM Drivers
WHERE DriverID NOT IN (
	SELECT DriverID
	FROM DC JOIN Cars ON DC.CarID = Cars.CarID
	WHERE Color = 'Red'
);

--РА
/*
((Drivers) WHERE [DriverID] MINUS 
	((DC JOIN Cars) WHERE Cars[Color] = 'Red')[DriverID])[DriverID, FIO]

--ИК
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS CARS WHERE Color = 'Red'

(DX.DriverID, DX.FIO) WHERE DX.DriverID <> 
	((DCX.DriverID) WHERE EXISTS CX (DCX.CarID = CX.CarID))
*/

--3)Найти водителей, получивших штрафов в общей сумме более чем на 100000 рублей
--SQL
SELECT DriverID, FIO
FROM Drivers
WHERE DriverID IN (
	SELECT DriverID
	FROM (
		SELECT DriverID, SUM(Amount) AS sumAmount
		FROM Fines
		GROUP BY DriverID
	) AS tmp
	WHERE sumAmount > 1000
);

--РА
(Drivers)[DriverID] INTERSECT 
	((SUMMARIZE Fines BY Fines[DriverID] ADD SUM(Amount) AS sumAmount) WHERE sumAmount > 1000) [DriverID]

--ИК
/*RANGE OF DX IS Drivers 
RANGE OF FX IS Fines

(DX.FIO, SUM(FX.Amount) AS sumAmount) WHERE sumAmount > 1000
*/