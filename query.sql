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
