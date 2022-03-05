--SQL
SELECT Fines.FineDate, Drivers.Phone
FROM Fines JOIN Drivers ON Fines.DriverID = Drivers.DriverID;

--РА
/*
(Fines JOIN Drivers) [FineDate, Phone]

--ИК
RANGE OF FX IS Fines
RANGE OF DX IS Drivers

(FX.FineDate, DX.Phone) WHERE EXISTS DX (DX.DriverID = FX.DriverID)
*/

--SQL
SELECT Drivers.DriverID, Drivers.FIO
FROM Cars JOIN DC ON Cars.CarID = DC.CarID
	JOIN Drivers ON DC.DriverID = Drivers.DriverID
WHERE Cars.Model = 'BMW';

--РА
/*
((Cars JOIN DC JOIN Drivers) WHERE Cars[Model] = 'BMW') [Drivers.DriverID, Drivers.FIO]

--ИК
RANGE OF CX IS Cars WHERE Cars.Model = 'BMW'
RANGE OF DCX IS DC
RANGE OF DX IS Drivers

(DX.DriverID, DX.FIO) WHERE EXISTS DCX (DCX.DriverID = DX.DriverID AND
				EXISTS CX (CX.CarID = DCX.CarID))
*/

--SQL
SELECT SUM(Amount)
FROM Fines JOIN Drivers ON Fines.DriverID = Drivers.DriverID
WHERE Drivers.FIO = 'Ivanov'
GROUP BY Fines.DriverID;

--РА
(SUMMARIZE ((Fines JOIN Drivers) WHERE Drivers[FIO] = 'Ivanov') PER Fines{DriverID} 
	ADD SUM(Amount) AS sumA) [sumA]

--ИК
RANGE OF FX IS Fines
RANGE OF DX IS Drivers WHERE Drivers.FIO = 'Ivanov'

SUM(FX.Amount WHERE EXISTS DX(DX.DriverID = FX.DriverID))












