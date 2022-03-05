--Создать хранимую процедуру с входным параметром – имя таблицы,
--которая выводит сведения об индексах указанной таблицы в текущей базе
--данных. Созданную хранимую процедуру протестировать.

DROP PROCEDURE IF EXISTS getIdx;
CREATE PROCEDURE getIdx(n VARCHAR(30))
AS $$
DECLARE
	a INT;
	curRow RECORD;
	tblCurs REFCURSOR;
		
BEGIN
	OPEN tblCurs FOR
		EXECUTE 'SELECT indexname FROM pg_indexes WHERE tablename =' || n;
	LOOP
		FETCH tblCurs INTO curRow;
		EXIT WHEN NOT FOUND;

		RAISE NOTICE '%', curRow.indexname;
				
	END LOOP;
	CLOSE tblCurs;
END;
$$ LANGUAGE PLpgSQL;


CALL getIdx('Teacher');
