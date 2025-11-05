import { PGlite } from '@electric-sql/pglite';
import fs from 'fs';

(async () => {
  const db = new PGlite();

  const createTables = fs.readFileSync('create-tables.sql', 'utf8');
  const insertCarsData = fs.readFileSync('insert-cars-data.sql', 'utf8');
  await db.exec(createTables);
  await db.exec(insertCarsData);

  const query = fs.readFileSync('query.sql', 'utf8');

  const response = await db.query(query);

  console.clear();
  console.table(response.rows);
})();
