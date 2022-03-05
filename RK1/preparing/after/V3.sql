--SQL
SELECT Drivers.DriverLicens, Cars.Color, Cars.Model
FROM Drivers JOIN DC ON Drivers.DriverID = DC.DriverID
	JOIN Cars ON DC.CarID = Cars.CarID;

--РА
/*
(Drivers JOIN DC JOIN Cars) [DriverLicense, Color, Model]

--ИК
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS Cars

(DX.DriverLiecens, CX.Color, CX.Model) WHERE EXISTS DCX (DCX.DriverID = DX.DriverID AND
						EXISTS CX (CX.CarID = DCX.CarID))
*/

--SQL
SELECT Drivers.FIO
FROM Drivers JOIN Fines ON Drivers.DriverID = Fines.DriverID
WHERE Amount < 5000 AND Amount > 500;

--РА
/*
((Drivers JOIN Fines) WHERE Fines[Amount] < 5000 AND Fines[Amount] > 500) [FIO]

--ИК
RANGE OF DX IS Drivers
RANGE OF FX IS Fines WHERE Fines.Amount < 5000 AND Fines.Amount > 500

(DX.FIO) WHERE EXISTS FX (FX.DriverID = DX.DriverID)
*/

--SQL
SELECT SUM(Amount)
FROM Fines
WHERE FineDate = 2018
GROUP BY Fines.FineID;

--РА
(SUMMARIZE (Fines WHERE YEAR(FineDate) = 2018) PER Fines[FineID] ADD SUM(Amount) AS sumA)[sumA]

--ИК
RANGE OF FX IS Fines WHERE YEAR(Fines.FineDate) = 2018

SUM(FX)







