--add a new column 'dealership_id' to the cars table
ALTER TABLE cars ADD COLUMN dealership_id INTEGER;

--set the dealership_id for all cars to 1
UPDATE cars SET dealership_id = 1 WHERE dealership_id IS NULL;

--give the dealership_id a not null constraint
ALTER TABLE cars ALTER COLUMN dealership_id SET NOT NULL;

--add a foreign key constraint to the dealership_id column
ALTER TABLE cars ADD CONSTRAINT dealership_fk FOREIGN KEY (dealership_id) REFERENCES dealerships(id);

--set not null constraints on existing columns in cars table
ALTER TABLE cars ALTER COLUMN brand SET NOT NULL, ALTER COLUMN model SET NOT NULL, ALTER COLUMN year SET NOT NULL, ALTER COLUMN price SET NOT NULL, ALTER COLUMN color SET NOT NULL, ALTER COLUMN condition SET NOT NULL, ALTER COLUMN sold SET NOT NULL;