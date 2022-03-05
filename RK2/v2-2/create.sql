DROP TABLE IF EXISTS SweetProvider;
DROP TABLE IF EXISTS Provider;
DROP TABLE IF EXISTS Sweet;
DROP TABLE IF EXISTS Shops;

CREATE TABLE Provider 
(
	ProviderID INT NOT NULL PRIMARY KEY,
	NameSweet VARCHAR(30) NOT NULL,
	INN VARCHAR(30),
	Address VARCHAR(30)
);

INSERT INTO Provider(ProviderID, NameSweet, INN, Address) VALUES
	(1, 'Name2', 'INN1', 'Addr1'),
	(2, 'Name5', 'INN2', 'Addr2'),
	(3, 'Name9', 'INN3', 'Addr3'),
	(4, 'Name2', 'INN4', 'Addr4'),
	(5, 'Name1', 'INN5', 'Addr5'),
	(6, 'Name10', 'INN6', 'Addr6'),
	(7, 'Name8', 'INN7', 'Addr7'),
	(8, 'Name5', 'INN8', 'Addr8'),
	(9, 'Name2', 'INN9', 'Addr9'),
	(10, 'Name3', 'INN10', 'Addr10');

SELECT * FROM Provider;

---------------------------------------------------------------------------
CREATE TABLE Sweet 
(
	SweetID INT NOT NULL PRIMARY KEY,
	SweetName VARCHAR(30) NOT NULL, 
	Contain VARCHAR(30),
	SweetDesc VARCHAR(30)
);

INSERT INTO Sweet(SweetID, SweetName, Contain, SweetDesc) VALUES
	(1, 'SweetName1', 'Contain1', 'SweetDesc1'),
	(2, 'SweetName2', 'Contain2', 'SweetDesc2'),
	(3, 'SweetName3', 'Contain3', 'SweetDesc3'),
	(4, 'SweetName4', 'Contain4', 'SweetDesc4'),
	(5, 'SweetName5', 'Contain5', 'SweetDesc5'),
	(6, 'SweetName6', 'Contain6', 'SweetDesc6'),
	(7, 'SweetName7', 'Contain7', 'SweetDesc7'),
	(8, 'SweetName8', 'Contain8', 'SweetDesc8'),
	(9, 'SweetName9', 'Contain9', 'SweetDesc9'),
	(10, 'SweetName10', 'Contain10', 'SweetDesc10');

SELECT * FROM Sweet;

---------------------------------------------------------------------------
CREATE TABLE Shops 
(
	ShopID INT NOT NULL PRIMARY KEY,
	ShopName VARCHAR(30) NOT NULL,
	Address VARCHAR(30),
	Register DATE,
	Rate INT
);

INSERT INTO Shops(ShopID, ShopName, Address, Register, Rate) VALUES
	(1, 'Name1', 'Addr1', '2020-01-15', 5),
	(2, 'Name2', 'Addr2', '2020-02-15', 3),
	(3, 'Name3', 'Addr3', '2020-03-15', 4),
	(4, 'Name4', 'Addr4', '2020-04-15', 5),
	(5, 'Name5', 'Addr5', '2020-05-15', 1),
	(6, 'Name6', 'Addr6', '2020-06-15', 0),
	(7, 'Name7', 'Addr7', '2020-07-15', 3),
	(8, 'Name8', 'Addr8', '2020-08-15', 2),
	(9, 'Name9', 'Addr9', '2020-09-15', 5),
	(10, 'Name10', 'Addr10', '2020-10-15', 2);

SELECT * FROM Shops;

---------------------------------------------------------------------------
CREATE TABLE SweetProvider 
(
	SweetID INT REFERENCES Sweet(SweetID) NOT NULL,
	ProviderID INT REFERENCES Provider(ProviderID) NOT NULL
);

INSERT INTO SweetProvider(SweetID, ProviderID) VALUES
	(1, 2), (1, 7), (1, 4),
	(2, 1), (2, 3),
	(3, 2),
	(4, 2), (4, 3), (4, 4),
	(5, 6), (5, 7),
	(6, 8), (6, 9), 
	(7, 1),
	(8, 5), 
	(9, 10),
	(10, 10);

SELECT * FROM SweetProvider;