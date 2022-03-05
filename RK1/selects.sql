SELECT Drivers.FIO, Cars.Year
FROM Cars JOIN DC ON Cars.CarID = DC.CarID
	JOIN Drivers ON Drivers.DriverID = DC.DriverID;

/*
(Cars JOIN DC JOIN Drivers)[FIO, Year]

--
RANGE OF CX IS Cars
RANGE OF DCX IS DC
RANGE OF DX IS Drivers

(DX.FIO, CX.Year) WHERE EXISTS DCX (DCX.CarID = CX.CarID AND
			EXISTS DX (DX.DriverID = DCX.DriverID))
*/

SELECT DriverID, FIO
FROM Drivers
WHERE DriverID <> ALL (
	SELECT DriverID
	FROM Cars JOIN DC ON Cars.CarID = DC.CarID
	WHERE Cars.Color = 'Red'
);

/*
((Drivers) WHERE Drivers[DriverID] <> (
	(Cars JOIN DC) WHERE Cars[Color] = 'Red')[DriverID])[DriverID, FIO]

--
RANGE OF DX IS Drivers
RANGE OF CX IS Cars WHERE Cars.Color = 'Red'
RANGE OF DCX IS DC

(DX.DriverID, DX.FIO) WHERE DX.DriverID <> (
		(DCX.DriverID) WHERE EXISTS CX (CX.CarID = DCX.CarID))
*/

SELECT DriverID, FIO
FROM Drivers
WHERE DriverID IN (
	SELECT DriverID
	FROM (
		SELECT DriverID, SUM(Amount) AS sumF
		FROM Fines
		GROUP BY DriverID
		ORDER BY DriverID
	) AS zxc
	WHERE sumF > 1000
);