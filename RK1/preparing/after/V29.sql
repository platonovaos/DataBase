--SQL
SELECT Drivers.FIO, Cars.Year
FROM Drivers JOIN DC ON Drivers.DriverID = DC.DriverID
	JOIN Cars ON DC.CarID = Cars.CarID;

--РА
/*
(Drivers JOIN DC JOIN Cars) [FIO, Year]

--ИК
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS Cars

(DX.FIO, DX.Year) WHERE EXISTS DCX (DCX.DriverID = DX.DriverID AND
			EXISTS CX (CX.CarID = DCX.CarID))
*/

--SQL
SELECT Fines.FineID, Fines.FineType
FROM Fines JOIN Drivers ON Fines.DriverID = Drivers.DriverID
	JOIN DC ON Drivers.DriverID = DC.DriverID
	JOIN Cars ON DC.CarID = Cars.CarID
WHERE Cars.RegDate = 2009;

--РА
/*
((Fines JOIN Drivers JOIN DC JOIN Cars) WHERE Cars[RegDate] = 2009) [FineID, FineType]

--ИК
RANGE OF FX IS Fines
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS Cars WHERE RegDate = 2009

(FX.FineID, FX.FineType) WHERE EXISTS DX (DX.DriverID = FX.DriverID AND
				EXISTS DCX (DCX.DriverID = DX.DriverID AND
				EXISTS CX (CX.CarID = DCX.CarID)))
*/

--SQL
SELECT Drivers.FIO, SUM(Amount)
FROM Fines JOIN Drivers ON Fines.DriverID = Drivers.DriverID
WHERE Drivers.FIO = 'Ivanov'
GROUP BY Drivers.FIO;

--РА
(SUMMARIZE ((Fines JOIN Drivers) WHERE Drivers[FIO] = 'Ivanov') 
	PER Drivers{FIO} ADD SUM(Amount) AS sumAmount)[sumAmount]

--ИК
RANGE OF DX IS Drivers WHERE Drivers.FIO = 'Ivanov'
RANGE OF FX IS Fines 

DX.FIO, SUM(FX.Amount WHERE EXISTS DX (FX.DriverID = DX.DriverID))










			