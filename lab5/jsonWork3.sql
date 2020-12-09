--Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или
--добавить атрибут с типом JSON к уже существующей таблице.
--Заполнить атрибут правдоподобными данными с помощью команд INSERT
--или UPDATE.
CREATE TEMP TABLE IF NOT EXISTS HCJSONB
(
	HotelID INT,
	CityID INT,
	Owner jsonb
);

INSERT INTO HCJSONB (CityID, HotelID, Owner)
VALUES (1, 14, '{"Surname" : "Ivanov", "Age" : 29, "Experience" : 4}'),
	(36, 5, '{"Surname" : "Petrov", "Age" : 51, "Experience" : 29}'),
	(71, 812, '{"Surname" : "Sidorov", "Age" : 68, "Experience" : 43}'),
	(88, 106, '{"Surname" : "Polyakov", "Age" : 41, "Experience" : 15}'),
	(90, 531, '{"Surname" : "Parinov", "Age" : 56, "Experience" : 33}');

SELECT * FROM HCJSONB;
