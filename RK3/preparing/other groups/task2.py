import psycopg2

def menu():
	print("\nChoose query:")
	print("\tQuery1........1")
	print("\tQuery2........2")
	print("\tQuery3........3")
	print("\tExit..........4")
	
	choose = input()
	return choose


def query1(con):
	cur = con.cursor()
	cur.execute('''SELECT *
					FROM Workers
					WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM Birthday) = (
						SELECT MIN(ageW)
						FROM (
							SELECT WorkerID, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM Birthday) AS ageW
							FROM Workers
							WHERE Dept = 'Counter'
						) AS res
					);''')

	res = cur.fetchall()
	for row in res:
		print('ID: ' + str(row[0]) + 'FIO: ' + str(row[1]) + 'Birth: ' + str(row[2]) + 'dept: ' + str(row[3]))



if __name__ == "__main__":

	con = psycopg2.connect(
		database = "RK3",
		user = "postgres",
		password = "",
		host = "localhost"
	)

	print("Database opened successfully")

	choose = 0
	while (choose != 4):
		choose = menu()
		if choose == 1:
			query1(con)

	
	con.close()