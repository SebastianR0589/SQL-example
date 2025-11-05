--SQL queries for the cars database
--select all data from cars table
SELECT * FROM cars;

--select data from the columns brand, model, price from cars table
SELECT brand, model, price FROM cars;

--select all black cars from cars table
SELECT * FROM cars WHERE color = 'black';

--select all cars that cost more than 30000 from cars table
SELECT * FROM cars WHERE price > 30000;

--select all cars that are not red from cars table
SELECT * FROM cars WHERE color != 'red';

--select all cars that are a form of green
SELECT * FROM cars WHERE color LIKE '%green%';

--select all cars that are not a form of blue
SELECT * FROM cars WHERE color NOT LIKE '%blue%';

--select all cars that are green and cost less than 25000
SELECT * FROM cars WHERE color LIKE '%green%' AND price < 25000;

--select all cars from the 80s
SELECT * FROM cars WHERE year BETWEEN 1980 AND 1989;

--select all cars that are either red or cost more than 40000
SELECT * FROM cars WHERE color = 'red' OR price > 40000;

--select all cars that are from either Toyota, Honda, or Ford
SELECT * FROM cars WHERE brand IN ('Toyota', 'Honda', 'Ford');

--select all cars that aren't sold yet
SELECT * FROM cars WHERE sold IS FALSE;

--select all cars ordered by price from lowest to highest
SELECT * FROM cars ORDER BY price ASC;

--select the top 5 most expensive cars
SELECT * FROM cars ORDER BY price DESC LIMIT 5;

--select the number of sold cars
SELECT COUNT(*) AS sold_cars FROM cars WHERE sold IS TRUE;

--select the total revenue from sold cars
SELECT SUM(price) AS total_revenue FROM cars WHERE sold IS TRUE;    

--select the most expensive car
SELECT MAX(price) AS most_expensive_car FROM cars;

--select the cheapest car
SELECT MIN(price) AS cheapest_car FROM cars;

--select the average price of all cars
SELECT FLOOR(AVG(price)) AS average_price FROM cars;

--select the number of cars for each brand
SELECT brand, COUNT(*) AS number_of_cars FROM cars GROUP BY brand;

--select all brands where more than 5 cars are available
SELECT brand, COUNT(*) AS number_of_cars FROM cars GROUP BY brand HAVING COUNT(*) > 5; 

--insert a new car into the cars table
INSERT INTO cars (brand, model, year, color, price, sold) VALUES ('Nissan', 'Altima', 2021, 'blue', 27000, FALSE);

--update the price of all red cars to be 5% more expensive
UPDATE cars SET price = price * 1.05 WHERE color = 'red';

--delete all cars that have a condition of 0
DELETE FROM cars WHERE condition = 0;

-------------------------------------------------------------------
--SQL queries for the dealerships table
--select all data from dealerships table
SELECT * FROM dealerships;

-------------------------------------------------------------------
--SQL queries for the staff table
--select all data from staff table 
SELECT * FROM staff;

-------------------------------------------------------------------
--SQL queries for Table joins
--Left join sold cars with cars
SELECT brand, model, price, sold, sold_price FROM sold_cars LEFT JOIN cars ON sold_cars.cars_id = cars.id;

--Right join staff with dealerships
SELECT name, role, city, state FROM staff RIGHT JOIN dealerships ON dealership_id = dealerships.id;

--Inner join staff with dealerships
SELECT name, role, city, state FROM staff INNER JOIN dealerships ON dealership_id = dealerships.id;

--Full join staff with sold cars
SELECT name, role, sold_price FROM staff FULL JOIN sold_cars ON staff.id = seller;

--Aggregate function with join to find average car price per dealership location
SELECT city, state, ROUND(AVG(price), 2) AS avg_price FROM cars	LEFT JOIN dealerships D ON dealership_id = D.id GROUP BY city, state;

--Total sales made by each salesperson
SELECT name, role, SUM(sold_price) AS total_sales FROM staff S LEFT JOIN sold_cars ON S.id = seller WHERE role = 'Salesperson' GROUP BY name, role ORDER BY total_sales DESC;

--Count of unsold cars per dealership location
SELECT city, state, COUNT(C.id) AS car_count FROM cars C RIGHT JOIN dealerships D ON dealership_id = D.id WHERE sold IS NOT TRUE GROUP BY city, state ORDER BY car_count;

--Details of sold cars including car info, seller name, dealership city, and formatted sold date
SELECT C.brand,	C.model, S.name AS seller_name,	D.city,	TO_CHAR(SC.sold_date, 'DD-MM-YYYY') AS date_of_sale FROM sold_cars SC INNER JOIN cars C ON SC.cars_id = C.id LEFT JOIN staff S ON SC.seller = S.id LEFT JOIN dealerships D ON S.dealership_id = D.id;

--List of salespersons who have not sold any cars along with their dealership location
SELECT S.name, S.role, D.city FROM sold_cars SC	FULL JOIN staff S ON SC.seller = S.id LEFT JOIN dealerships D ON S.dealership_id = D.id WHERE SC.id IS NULL	AND S.role = 'Salesperson';

--Number of cars sold per dealership location
SELECT D.city, D.state,	COUNT(SC.id) AS cars_sold FROM sold_cars SC	LEFT JOIN cars C ON SC.cars_id = C.id RIGHT JOIN dealerships D ON C.dealership_id = D.id GROUP BY D.city, D.state ORDER BY cars_sold DESC;