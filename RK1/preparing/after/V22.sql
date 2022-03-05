--SQL
SELECT Fines.FineDate, Drivers.Phone
FROM Fines JOIN Drivers ON Fines.DriverID = Drivers.DriverID;

--РА
/*
(Fines JOIN Drivers) [FineDate, Phone]

--ИК
RANGE OF FX IS Fines
RANGE OF DX IS Drivers

(FX.FineDate, DX.Phone) WHERE EXISTS DX (DX.DriverID = FX.FineDate)
*/

--SQL
SELECT Cars.CarID, Cars.Model
FROM Cars JOIN DC ON Cars.CarID = DC.CarID
	JOIN Drivers ON DC.DriverID = Drivers.DriverID
WHERE Drivers.FIO = 'Ivanov';

--РА
/*
((Cars JOIN DC JOIN Drivers) WHERE Drivers[FIO] = 'Ivanov') [Cars.CarID, Cars.Model]

--ИК
RANGE OF CX IS Cars
RANGE OF DCX IS DC
RANGE OF DX IS Drivers

(CX.CarID, CX.Model) WHERE EXISTS DCX (DCX.CarID = CX.CarID AND
			EXISTS DX (DX.DriverID = DCX.DriverID))
*/

--SQL
SELECT FineDate, COUNT(*) AS cnt
FROM Fines
GROUP BY FineDate
HAVING COUNT(*) = (
	SELECT MAX(cnt)
	FROM (
		SELECT COUNT(*) AS cnt
		FROM Fines
		GROUP BY FineDate
	) AS tmp
);

/*
--РА
SUMMARIZE ((SUMMARIZE Fines PER Fines{FineDate} ADD COUNT AS cnt))
	PER Fines{FineDate} ADD MAX(cnt) AS max

--ИК
RANGE OF FX IS Fines
RANGE OF FY IS Fines

FX.FineDate, MAX(COUNT(FY.FineDate WHERE EXISTS FX.FineID = FY.FineID))
*/




