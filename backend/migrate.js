const fs = require('node:fs');
const path = require('node:path');
const mysql = require('mysql2/promise');

const requiredVariables = ['DB_HOST', 'DB_NAME', 'DB_USER', 'DB_PASSWORD'];
const missingVariables = requiredVariables.filter(
  (name) => !process.env[name]
);

if (missingVariables.length > 0) {
  console.error(
    `Missing required database environment variables: ${missingVariables.join(', ')}`
  );
  process.exit(1);
}

async function runMigration() {
  let connection;

  try {
    const migrationPath = path.join(
      __dirname,
      'migrations',
      '001_initial_schema.sql'
    );

    const sql = fs.readFileSync(migrationPath, 'utf8');

    connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      port: Number(process.env.DB_PORT || 3306),
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      multipleStatements: true,
      connectTimeout: 10000
    });

    await connection.query(sql);

    const [rows] = await connection.query(
      'SELECT COUNT(*) AS cake_count FROM cakes'
    );

    console.log('DATABASE MIGRATION SUCCESSFUL');
    console.log(`Cake records present: ${rows[0].cake_count}`);
  } catch (error) {
    console.error('DATABASE MIGRATION FAILED:', error.message);
    process.exitCode = 1;
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

runMigration();
