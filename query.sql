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

-------------------------------------------------------------------
--Advanced SQL queries
--Select all cars that cost more than any car sold by 'Frankie Fender'
SELECT brand, model, price FROM cars WHERE price > ANY (SELECT SC.sold_price FROM sold_cars SC JOIN staff S ON SC.seller = S.id WHERE S.name = 'Frankie Fender') AND sold IS FALSE;

--Find all Volkswagen that are cheaper than any Ford car
SELECT brand, model, price FROM cars WHERE price < ANY (SELECT price FROM cars WHERE brand = 'Ford') AND brand = 'Volkswagen';

--List all staff members who have sold a car for more than the average sold price of all cars
SELECT S.name, SC.sold_price FROM staff S JOIN sold_cars SC ON S.id = SC.seller WHERE SC.sold_price > ANY (SELECT SUM(sold_price) FROM sold_cars GROUP BY seller);

--Find all cars that are more expensive than the total sales made by any dealership
SELECT brand, model, price FROM cars WHERE price > ANY (SELECT SUM(sold_price) FROM sold_cars JOIN staff ON staff.id = sold_cars.seller GROUP BY staff.dealership_id);

--Select all cars that are cheaper than all cars with a condition rating of 3
SELECT brand, model, condition, price FROM cars WHERE price < ALL (SELECT price FROM cars WHERE condition = 3);

--Find all cars that are older than all Ford cars
SELECT brand, model, year FROM cars WHERE year < ALL (SELECT year FROM cars WHERE brand = 'Ford') ORDER BY year;

--List all cars that cost more than all sold cars
SELECT brand, model, city, price FROM cars JOIN dealerships ON dealership_id = dealerships.id WHERE price > ALL (SELECT sold_price FROM sold_cars) ORDER BY city;

--Select all colors of cars that have never been sold
SELECT DISTINCT color FROM cars WHERE NOT EXISTS (SELECT 1 FROM sold_cars WHERE cars_id = cars.id) ORDER BY color;

--Find all dealership locations that have no cars in their inventory
SELECT city, state, TO_CHAR(established, 'YYYY-MM-DD') AS est FROM dealerships D WHERE NOT EXISTS (SELECT 1 FROM cars WHERE dealership_id = D.id);

--List all dealership locations that have at least one car priced over 50000
SELECT city, state FROM dealerships DWHERE EXISTS (SELECT 1 FROM cars CWHERE C.dealership_id = D.id AND C.price > 50000);

--Find all salespersons who have not sold any car for more than 45000
SELECT name FROM staff S WHERE role = 'Salesperson' AND NOT EXISTS (SELECT 1 FROM sold_cars SC WHERE SC.seller = s.id AND SC.sold_price > 45000) ND EXISTS (SELECT 1 FROM sold_cars SC where seller = s.id);

--Select all cars and categorize them based on their condition
SELECT brand, model, condition, CASE WHEN condition >= 4 THEN 'Excellent' WHEN condition >= 3 THEN 'Fair' WHEN condition >= 1 THEN 'Poor' ELSE 'Wrecked' END AS condition_label FROM cars ORDER BY condition DESC;

--Calculate bonuses for sales staff based on their total sales
SELECT S.name, S.role, S.dealership_id, SUM(SC.sold_price) AS total_sales, CASE WHEN SUM(SC.sold_price) >= 100000 THEN 10000 WHEN SUM(SC.sold_price) >= 75000 THEN 5000 ELSE 1000 END AS bonus FROM sold_cars SC RIGHT JOIN staff S ON SC.seller = S.id GROUP BY (S.name, S.role, S.dealership_id) ORDER BY bonus, dealership_id;

--Select all unsold cars that meet minimum condition requirements based on their year
SELECT brand, model, condition, year, price FROM cars WHERE sold IS FALSE AND CASE WHEN year <= 1960 THEN condition >= 4 WHEN year <= 1970 THEN condition >= 3 WHEN year <= 1980 THEN condition >= 2 WHEN year <= 1990 THEN condition >= 1 ELSE TRUE END ORDER BY year, condition;

--Select all unsold cars with price limits based on their condition rating
SELECT brand, model, condition, price FROM cars WHERE sold IS FALSE	AND CASE WHEN condition >= 4 THEN price < 100000 WHEN condition >= 3 THEN price < 50000 WHEN condition >= 1 THEN price < 20000 ELSE TRUE END ORDER BY condition;

--Update prices of unsold Aston Martin cars based on model type
UPDATE cars SET price = price * CASE WHEN model = 'DB5' THEN 1.15 WHEN model LIKE 'DB_' THEN 1.1 ELSE 1.05 END WHERE sold IS FALSE AND brand = 'Aston Martin';

--Update prices of unsold cars based on dealership location
UPDATE cars SET price = price * CASE WHEN dealership_id = 1 THEN 1.2 WHEN dealership_id = 3 THEN 0.8 ELSE 1.0 END WHERE sold IS FALSE;

--Generate a performance report for each dealership based on total sales
SELECT D.city, COUNT(sc.id) AS total_sales, CASE WHEN COUNT(sc.id) >= 10 THEN 'Outperforming' WHEN COUNT(sc.id) >= 5 THEN 'Meeting targets' WHEN COUNT(sc.id) >= 1 THEN 'Underperforming' ELSE 'No sales' END AS performance_level FROM dealerships D LEFT JOIN staff S ON S.dealership_id = D.id LEFT JOIN sold_cars sc ON sc.seller = S.id GROUP BY D.city ORDER BY total_sales;

--Count of sold cars per quarter
SELECT CASE	WHEN EXTRACT(MONTH FROM sold_date) IN (1,2,3) THEN 'Q1'	WHEN EXTRACT(MONTH FROM sold_date) IN (4,5,6) THEN 'Q2' WHEN EXTRACT(MONTH FROM sold_date) IN (7,8,9) THEN 'Q3'	ELSE 'Q4' END AS quarter, COUNT(*) AS sold_cars FROM sold_cars GROUP BY quarter	ORDER BY quarter;