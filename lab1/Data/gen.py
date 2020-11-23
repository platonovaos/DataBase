from random import randint
from random import choice

from mimesis import Business
from mimesis import Address
from mimesis import Datetime
from mimesis import Person

from collections import defaultdict
import csv

NUM = 1000

category = ["BB", "HB", "FB", "AI", "UAI", "HB+", "FB+"]

def generateFood():
	f = open('food.csv', 'w')
	for i in range(NUM):
		cat = choice(category)
		veg = randint(0, 1)
		child = randint(0, 1)
		bar = randint(0, 1)
		cost = randint(150, 2500)
		line = "{0},{1},{2},{3},{4},{5}\n".format(i+1, cat, veg, child, bar, cost)
		f.write(line)
	f.close()


typeHotel = ["Hostel", "Mini", "Resort", "Guest house", "Apart", "B&B", "Business", "Motel", "Spa"]

def generateHotel():
	corp = Business('en')

	hotelUnique = set()
	while (len(hotelUnique) < NUM):
		name = corp.company()
		while ("Inc" in name or "LLC" in name or len(name) > 45 or "." in name):
			name = corp.company()
		hotelUnique.add(name)

	f = open('hotel.csv', 'w')
	fr = open('hc_temp.txt', 'w')
	for i in range(NUM):
		city = randint(1, NUM)
		name = hotelUnique.pop()
		typeH = choice(typeHotel)
		classH = randint(0, 5)
		SP = randint(0, 1)
		cost = randint(500, 25000)
		line = "{0},{1},{2},{3},{4},{5},{6}\n".format(i+1, city, name, typeH, classH, SP, cost)
		f.write(line)
		line1 = "{0} {1}\n".format(city, i+1)
		fr.write(line1)
	f.close()
	fr.close()


def generateTour():
	dt = Datetime()

	f = open('tour.csv', 'w')
	for i in range(NUM):
		food = randint(1, NUM)
		hotel = randint(1, NUM)
		cost = randint(500, 100000)
		dateB = dt.date(2020, 2021)
		dateE = dt.date(2020, 2021)
		if (dateB >= dateE):
			dateB, dateE = dateE, dateB
		line = "{0},{1},{2},{3},{4},{5}\n".format(i+1, food, hotel, cost, dateB, dateE)
		f.write(line)
	f.close()


def generateCity():
	ct = Address('en')
	
	ciytyUnique = set()
	while (len(ciytyUnique) < NUM):
		ciytyUnique.add(ct.city())
	
	f = open('city.csv', 'w')	
	for i in range(NUM):
		line = "{0},{1}\n".format(i+1, ciytyUnique.pop())
		f.write(line)
	f.close()


def generateHC():
	per = Person('en')

	data = []
	with open("hc_temp.txt") as f:
		for line in f:
			data.append([int(x) for x in line.split()])
	f.close()
	
	f = open('hc.csv', 'w')
	for i in range(NUM):
		for j in range(len(data)):
			if (data[j][0] == i):
				hotel = data[j][1]	
				name = per.full_name()
				line = "{0},{1},{2}\n".format(i, hotel, name)
				f.write(line)
		hotel = randint(1, NUM)
		name = per.full_name()
		line = "{0},{1},{2}\n".format(i+1, hotel, name)
		f.write(line)
	f.close()


def generateFalseHotel():
	corp = Business('en')

	f = open('hotel.csv', 'w')
	fr = open('hc_temp.txt', 'w')
	for i in range(NUM):
		city = randint(1, NUM)
		
		name = corp.company()
		while ("Inc" in name or "LLC" in name or len(name) > 45 or "." in name):
			name = corp.company()

		typeH = choice(typeHotel)
		classH = randint(0, 5)
		SP = randint(0, 1)
		cost = randint(500, 25000)
		line = "{0},{1},{2},{3},{4},{5},{6}\n".format(i+1, city, name, typeH, classH, SP, cost)
		f.write(line)
		line1 = "{0} {1}\n".format(city, i+1)
		fr.write(line1)
	f.close()
	fr.close()

if __name__ == "__main__":
	generateFood()
	generateHotel()
	generateTour()
	generateCity()
	generateHC()
	
