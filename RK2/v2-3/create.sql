DROP TABLE IF EXISTS LesTe;
DROP TABLE IF EXISTS Lesson;
DROP TABLE IF EXISTS Teacher;
DROP TABLE IF EXISTS Cafedra;

CREATE TABLE Cafedra 
(
	ID INT NOT NULL PRIMARY KEY,
	CafedraName VARCHAR(30) NOT NULL,
	CafedraDesc VARCHAR(30)
);

INSERT INTO Cafedra(ID, CafedraName, CafedraDesc) VALUES
	(1, 'Name1', 'CafedraDesc1'),
	(2, 'Name2', 'CafedraDesc1'),
	(3, 'Name3', 'CafedraDesc1'),
	(4, 'Name4', 'CafedraDesc1'),
	(5, 'Name5', 'CafedraDesc1'),
	(6, 'Name6', 'CafedraDesc1'),
	(7, 'Name7', 'CafedraDesc1'),
	(8, 'Name8', 'CafedraDesc1'),
	(9, 'Name9', 'CafedraDesc1'),
	(10, 'Name10', 'CafedraDesc1');

SELECT * FROM Cafedra;

---------------------------------------------------------------------------
CREATE TABLE Teacher 
(
	ID INT NOT NULL PRIMARY KEY,
	CafedraID INT REFERENCES Cafedra(ID) NOT NULL,
	FIO VARCHAR(30) NOT NULL,
	Degree INT,
	Status VARCHAR(30)
);

INSERT INTO Teacher(ID, CafedraID, FIO, Degree, Status) VALUES
	(1, 1, 'FIO1', 0, 'Status1'),
	(2, 1, 'FIO2', 0, 'Status2'),
	(3, 8, 'FIO3', 4, 'Status3'),
	(4, 3, 'FIO4', 3, 'Status4'),
	(5, 6, 'FIO5', 4, 'Status5'),
	(6, 5, 'FIO6', 2, 'Status6'),
	(7, 3, 'FIO7', 1, 'Status7'),
	(8, 3, 'FIO8', 2, 'Status8'),
	(9, 2, 'FIO9', 0, 'Status9'),
	(10, 6, 'FIO10', 3, 'Status10');

SELECT * FROM Teacher;

---------------------------------------------------------------------------

CREATE TABLE Lesson 
(
	ID INT NOT NULL PRIMARY KEY,
	LessonName VARCHAR(30) NOT NULL,
	NumHour INT,
	Semestr INT,
	Rate INT
);

INSERT INTO Lesson(ID, LessonName, NumHour, Semestr, Rate) VALUES
	(1, 'Name1', 355, 1, 80),
	(2, 'Name2', 124, 1, 30),
	(3, 'Name3', 566, 4, 90),
	(4, 'Name4', 367, 7, 85),
	(5, 'Name5', 695, 2, 83),
	(6, 'Name6', 236, 3, 36),
	(7, 'Name7', 907, 5, 74),
	(8, 'Name8', 356, 1, 68),
	(9, 'Name9', 678, 2, 48),
	(10, 'Name10', 274, 6, 94);

SELECT * FROM Lesson;

---------------------------------------------------------------------------
CREATE TABLE LesTe 
(
	TeacherID INT REFERENCES Teacher(ID) NOT NULL,
	LessonID INT REFERENCES Lesson(ID) NOT NULL,
	Expert INT
);

INSERT INTO LesTe(TeacherID, LessonID, Expert) VALUES
	(1, 1, 3),
	(1, 2, 30),
	(1, 3, 23),
	(2, 2, 67),
	(3, 3, 18),
	(3, 4, 22),
	(6, 7, 20),
	(7, 3, 31),
	(8, 9, 32),
	(8, 10, 15);

SELECT * FROM LesTe;