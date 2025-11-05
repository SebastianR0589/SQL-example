 CREATE TABLE IF NOT EXISTS cars (
    id SERIAL PRIMARY KEY,
    brand TEXT,
    model TEXT,
    year INTEGER,
    price INTEGER,
    color TEXT,
    condition INTEGER,
    sold BOOLEAN
  );

  CREATE TABLE IF NOT EXISTS dealerships (
    id SERIAL PRIMARY KEY,
    city TEXT NOT NULL,
    state CHAR(2) NOT NULL,
    established DATE NOT NULL
  );

  CREATE TABLE IF NOT EXISTS staff (
	id SERIAL PRIMARY KEY,
	dealership_id INTEGER NOT NULL REFERENCES dealerships(id)
	name TEXT NOT NULL,
	role TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS sold_cars (
    id SERIAL PRIMARY KEY,
    cars_id INTEGER NOT NULL REFERENCES cars(id),
    seller INTEGER NOT NULL REFERENCES staff(id),
    sold_date DATE NOT NULL,
    sold_price INTEGER NOT NULL
  )