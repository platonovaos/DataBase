from py_linq import Enumerable

hotels = Enumerable(
	[{'HotelID': 1, 'City': 703, 'Name': 'Goodrich Corporation', 'Type': 'Mini', 'Class': 4, 'SwimPool': 'true', 'Cost': 16895},
	{'HotelID': 2, 'City': 223, 'Name': 'Profitpros', 'Type': 'Resort', 'Class': 5, 'SwimPool': 'false', 'Cost': 7039},
	{'HotelID': 3, 'City': 86, 'Name': 'Continental Airlines', 'Type': 'B&B', 'Class': 2, 'SwimPool': 'true', 'Cost': 2368},
	{'HotelID': 4, 'City': 157, 'Name': 'Quality Realty Service', 'Type': 'Mini', 'Class': 0, 'SwimPool': 'true', 'Cost': 19073},
	{'HotelID': 5, 'City': 595, 'Name': 'Master Builder Design Services', 'Type': 'Hostel', 'Class': 3, 'SwimPool': 'false', 'Cost': 19793}])

group = Enumerable([{'Class': 0}, {'Class': 1}, {'Class': 2}, {'Class': 3}, {'Class': 4}, {'Class': 5}])

hotelsRes = hotels.where(lambda x: x['Class'] > 2) \
			.select(lambda x: x['Name']) \
			.order_by(lambda x: x) \
			.distinct() \
			.count()
			
query1 = hotels.any(lambda x: 'Mini' in x['Type'])

print(query1)