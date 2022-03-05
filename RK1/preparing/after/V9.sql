--1.Найти все пары вида <ФИО водителя, дата регистрации его автомобиля>
SELECT Drivers.FIO, Cars.Year
FROM Drivers JOIN DC ON Drivers.DriverID = DC.DRiverID
	JOIN Cars ON DC.CarID = Cars.CarID;

--РА
/*
(Drivers JOIN DC JOIN Cars) [FIO, Year]

--ИК
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS Cars

(DX.FIO, CX.Year) WHERE EXISTS DCX (DCX.DriverID = DX.DriverID AND
			EXISTS CX (CX.CarID = DCX.CarID))
*/

--2.Найти телефоны водителей, у которых есть белая машина 2018 года выпуска
SELECT Drivers.Phone
FROM Drivers JOIN DC ON Drivers.DriverID = DC.DriverID
	JOIN Cars ON DC.CarID = Cars.CarID
WHERE Cars.Color = 'Black' AND Cars.Year = 2011;

--РА
/*
((Drivers JOIN DC JOIN Cars) WHERE Cars[Color] = 'Black' AND Cars[Year] = 2011) [Phone]

--ИК
RANGE OF DX IS Drivers
RANGE OF DCX IS DC
RANGE OF CX IS Cars WHERE Color = 'Black' AND Year = 2011

(DX.Phone) WHERE EXISTS DCX (DCX.DriverID = DX.DriverID AND
		EXISTS CX (CX.CarID = DCX.CarID))
*/

--3.Найти машины, которыми владеют более 2х водителей
SELECT Cars.CarID, Cars.Model, COUNT(DC.DriverID)
FROM Cars JOIN DC ON Cars.CarID = DC.CarID
GROUP BY Cars.CarID, Cars.Model
HAVING COUNT(DC.DriverID) > 1;

--РА
/*
(SUMMARIZE (Cars JOIN DC) PER Cars{CarID, Model} ADD COUNT(DC[DriverID]) AS cnt) WHERE cnt > 1

--ИК
RANGE OF CX IS Cars
RANGE OF DCX IS DC

(CX.CarID, CX.Model) WHERE EXISTS DCX (DCX.CarID = CX.CarID) AND
			EXISTS COUNT(DCX.DriverID) AS cnt WHERE cnt > 1
*/

--4.Найти водителей, получивших штрафов в общей сумме более чем на 100000 рублей
SELECT FIO, SUM(Amount)
FROM Fines JOIN Drivers ON Fines.DriverID = Drivers.DriverID
GROUP BY FIO, Fines.DriverID
HAVING SUM(Amount) > 1000;

--ИК
/*
(SUMMARIZE (Fines JOIN Drivers) PER Drivers{FIO} ADD SUM(Amount) AS sumAmount) WHERE sumAmount > 1000

--РА
RANGE OF FX IS Fines
RANGE OF DX IS Drivers

(DX.FIO) WHERE EXISTS FX (FX.DriverID = DX.DriverID AND
			EXISTS SUM(FX.Amount) AS sumAmount WHERE sumAmount > 1000)

*/


