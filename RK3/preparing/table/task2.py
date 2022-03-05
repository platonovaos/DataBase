import psycopg2

def menu:
	print("\nChoose query:")
	print("\tQuery1........1")
	print("\tQuery2........2")
	print("\tQuery3........3")
	print("\tExit..........4")
	
	choose = input()
	return choose


def query1(con):
	cur = con.cursor()
	cur.execute('''SELECT Tour.TourID, Tour.Cost
					FROM Tour JOIN Food ON Tour.Food = Food.FoodID
					WHERE Tour.Cost > 70000 AND Food.Bar = TRUE
					ORDER BY Tour.TourID;''')

	res = cur.fetchmany(size = 5)
	for row in res:
		print('TourID = ' + str(row[0]) + ' Cost: ' + str(row[1]))



if __name__ == "__main__":

	con = psycopg2.connect(
		database = "RK3",
		user = "postgres",
		password = "",
		host = "localhost"
	)

	print("Database opened successfully")

	choose = 0
	while (choose != 11):
		choose = menu()
		if choose == 1:
			query1(con)

	
	con.close()