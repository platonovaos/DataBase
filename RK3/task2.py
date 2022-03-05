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
					WHERE CURRENT_DATE - Birthday = (
						SELECT MAX(ageW)
						FROM (
							SELECT WorkerID, CURRENT_DATE - Birthday AS ageW
							FROM Workers
							WHERE Dept = 'Counter'
						) AS res
					) AND Dept = 'Counter';''')

	res = cur.fetchall()
	for row in res:
		print('ID: ' + str(row[0]) + ', FIO: ' + str(row[1]) + 
				', Birth: ' + str(row[2]) + ', Dept: ' + str(row[3]))


def query2(con):
	cur = con.cursor()
	cur.execute('''SELECT *
					FROM Workers
					WHERE WorkerID IN (
						SELECT WorkerID
						FROM (
							SELECT WorkerID, DateIO, COUNT(DateIO)
							FROM IOWorkers
							WHERE TypeIO = 2
							GROUP BY WorkerID, DateIO
							HAVING COUNT(DateIO) > 3
						) AS tmp1
					);''')

	res = cur.fetchall()
	for row in res:
		print('ID: ' + str(row[0]) + ', FIO: ' + str(row[1]) + 
				', Birth: ' + str(row[2]) + ', Dept: ' + str(row[3]))


def query3(con):
	cur = con.cursor()
	cur.execute('''SELECT *
					FROM Workers
					WHERE WorkerID = (
						SELECT WorkerID
						FROM IOWorkers
						WHERE TimeIO = (
							SELECT MAX(ti)
							FROM (
								SELECT WorkerID, MIN(TimeIO) AS ti
								FROM IOWorkers
								WHERE DateIO = CURRENT_DATE AND TypeIO = 1
								GROUP BY WorkerID
							) AS tmp
						) AND TypeIO = 1 AND DateIO = CURRENT_DATE
					);''')

	res = cur.fetchall()
	for row in res:
		print('ID: ' + str(row[0]) + ', FIO: ' + str(row[1]) + 
				', Birth: ' + str(row[2]) + ', Dept: ' + str(row[3]))



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
		if choose == 2:
			query2(con)
		if choose == 3:
			query3(con)

	
	con.close()