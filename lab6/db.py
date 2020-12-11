import psycopg2

def menu():
	print("\nChoose query:")
	print("\tScalar query........1")
	print("\tJOIN query..........2")
	print("\tWindow function.....3")
	print("\tMetadata............4")
	print("\tScalar function.....5")
	print("\tTable function......6")
	print("\tProcedure...........7")
	print("\tExit...............11")
	
	choose = input()
	return choose


def scalarQuery(con):
	cur = con.cursor()
	cur.execute('''SELECT Tour.TourID, Tour.Cost
					FROM Tour JOIN Food ON Tour.Food = Food.FoodID
					WHERE Tour.Cost > 70000 AND Food.Bar = TRUE
					ORDER BY Tour.TourID;''')

	res = cur.fetchmany(size = 5)
	for row in res:
		print('TourID = ' + str(row[0]) + ' Cost: ' + str(row[1]))


def joinQuery(con):
	cur = con.cursor()
	cur.execute('''SELECT MIN(Food.Cost) AS FoodMin,
							MIN(Hotel.Cost) AS HotelMin
					FROM Tour RIGHT JOIN Food ON Tour.Food = Food.FoodID
					LEFT JOIN Hotel ON Hotel.HotelID = Tour.Hotel
					WHERE (Tour.DateEnd - Tour.DateBegin) > 7;''')

	res = cur.fetchone()
	print('FoodMinCost: ' + str(res[0]) + ' HotelMinCost: ' + str(res[1]))


def windowFunction(con):
	cur = con.cursor()
	cur.execute('''SELECT Hotel.HotelID, Food.Category,
							AVG(Hotel.Cost) OVER (PARTITION BY Hotel.Class) AS AvgCostClass,
							AVG(Food.Cost) OVER (PARTITION BY Food.Category) AS AvgCostFood
					FROM Tour RIGHT JOIN Food ON Tour.Food = Food.FoodID
					LEFT JOIN Hotel ON Hotel.HotelID = Tour.Hotel
					WHERE HotelID IS NOT NULL
					ORDER BY HotelID;''')

	res = cur.fetchmany(size = 5)
	for row in res:
		print('HotelID = ' + str(row[0]) + ' Category: ' + row[1] + 
				'\n\tAvgHCost: ' + str(round(row[2])) + '\n\tAvgFCost: ' + str(round(row[3])))	


def metadata(con):
	cur = con.cursor()
	cur.execute('''SELECT table_name, pg_table_size(cast(table_name AS VARCHAR)) as size
					FROM information_schema.tables
					WHERE table_schema = 'public';''')

	res = cur.fetchall()
	for row in res:
		print('Name: ' + row[0] + ', Size: ' + str(row[1]))


def scalarFunction(con):
	cur = con.cursor()
	cur.callproc('''avgCostTopHotels''')

	res = cur.fetchone()
	print('avgCostTopHotels: ' + str(res[0]))


def tableFunction(con):
	cur = con.cursor()
	cur.callproc('costFoodParams',['HB+', 'true', 'true', 'true'])

	res = cur.fetchmany(size = 5)
	for row in res:
		print('FoodID = ' + str(row[0]) + ', Category: ' + row[1] + ', Cost: ' + str(row[2]))


def procedure(con):
	cur = con.cursor()
	cur.execute('''CALL incPricesInBigCities(500);''')
	cur.execute('''CALL incPricesInBigCities(-500);''')

	print("Procedure executed")



if __name__ == "__main__":

	con = psycopg2.connect(
		database = "TOURS",
		user = "postgres",
		password = "",
		host = "localhost"
	)

	print("Database opened successfully")

	choose = 0
	while (choose != 11):
		choose = menu()
		if choose == 1:
			scalarQuery(con)
		if choose == 2:
			joinQuery(con)
		if choose == 3:
			windowFunction(con)
		if choose == 4:
			metadata(con)
		if choose == 5:
			scalarFunction(con)
		if choose == 6:
			tableFunction(con)
		if choose == 7:
			procedure(con)

	
	con.close()

