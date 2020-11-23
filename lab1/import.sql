COPY City(CityID, Name) from '/home/main/Desktop/BMSTU/5sem/DataBase/lab1/mimesis/city.csv' 
delimiter ',' csv;

COPY Food(FoodID, Category, VegMenu, ChildrenMenu, Bar, Cost) from '/home/main/Desktop/BMSTU/5sem/DataBase/lab1/mimesis/food.csv' 
delimiter ',' csv;

COPY Hotel(HotelID, City, Name, Type, Class, SwimPool, Cost) from '/home/main/Desktop/BMSTU/5sem/DataBase/lab1/mimesis/hotel.csv' 
delimiter ',' csv;

COPY Tour(TourID, Food, Hotel, Cost, DateBegin, DateEnd) from '/home/main/Desktop/BMSTU/5sem/DataBase/lab1/mimesis/tour.csv' 
delimiter ',' csv;

COPY HC(CityID, HotelID, Owner) from '/home/main/Desktop/BMSTU/5sem/DataBase/lab1/mimesis/hc.csv' 
delimiter ',' csv;

