--SQL
SELECT Drivers.FIO, Cars.Year
FROM Drivers JOIN DC ON Drivers.DriverID = DC.DriverID
	JOIN Cars ON DC.CarID = Cars.CarID;

--ИК
/*
(Drivers JOIN DC JOIN Cars)[FIO, Year]

--РА
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS Cars

(DX.FIO, CX.Year) WHERE EXISTS DCX(DCX.DriverID = DX.DriverID AND
			EXISTS CX (CX.CarID = DCX.CarID))
*/

--SQL
SELECT FineID, FineType
FROM Fines JOIN Drivers ON Drivers.DriverID = Fines.DriverID
	JOIN DC ON DC.DriverID = Drivers.DriverID
	JOIN Cars ON Cars.CarID = DC.CarID
WHERE Cars.RegDate = 2009;

--ИК
/*
((Cars JOIN DC JOIN Drivers JOIN Fines) WHERE Cars[RegDate] = 2009) [FineID, FineType]

--РА
RANGE OF CX IS Cars WHERE RegDate = 2009
RANGE OF DCX IS DC
RANGE OF DX IS Drivers
RANGE OF FX IS Fines

(FX.FineID, FX.FineType) WHERE EXISTS DX (DX.DriverID = FX.DriverID AND
				EXISTS DCX (DCX.DriverID = DX.DriverID AND
				EXISTS CX (CX.CarID = DCX.CarID)))
*/

--SQL
SELECT FineDate, COUNT(*)
FROM Fines
GROUP BY FineDate;

--ИК
SUMMARIZE (Fines) PER Fines{FineDate} ADD COUNT AS cnt;

--РА
RANGE OF FX IS Fines
RANGE OF FY IS Fines

FX.FineDate, COUNT(FY WHERE (FX.FineDate = FY.FiNEDate))


