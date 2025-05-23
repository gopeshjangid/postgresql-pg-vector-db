// db.js

// Import the Pool class from the pg library
const { Pool } = require('pg');

// --- Database Connection Configuration ---
// It's highly recommended to use environment variables for sensitive data
const dbConfig = {
  user: process.env.DB_USER || 'root', // Default PostgreSQL user, use env var in production
  host: process.env.DB_HOST || 'localhost', // Use 'localhost' for local tunnel, private IP for EC2 in same VPC
  database: process.env.DB_NAME || 'postgres', // Default database name
  password: process.env.DB_PASSWORD || 'Tiger123', // Your database password, use env var in production
  port: process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 5432, // Default PostgreSQL port
};

// Create a new Pool instance
// This pool will manage multiple connections to your database
const pool = new Pool(dbConfig);

// --- Event listeners for the pool (optional but recommended for monitoring) ---
pool.on('connect', client => {
  console.log('New client connected to the database pool.');
});

pool.on('acquire', client => {
  console.log('Client acquired from pool.');
});

pool.on('remove', client => {
  console.log('Client removed from pool.');
});

pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
  // If a client has an unrecoverable error, it will be removed from the pool
  // and the pool will try to create a new one.
});


// --- Helper function to execute queries using the pool ---
/**
 * Executes a SQL query using the connection pool.
 * Automatically acquires and releases a client from the pool.
 * @param {string} text - The SQL query string.
 * @param {Array<any>} [params] - An optional array of query parameters.
 * @returns {Promise<import('pg').QueryResult<any>>} - A promise that resolves with the query result.
 */
async function query(text, params) {
  const client = await pool.connect(); // Get a client from the pool
  try {
    const result = await client.query(text, params); // Execute the query
    return result;
  } catch (err) {
    console.error('Error executing query:', text, params, err);
    throw err; // Re-throw the error so calling code can handle it
  } finally {
    client.release(); // Release the client back to the pool
  }
}

// --- Export the query function and the pool for use in other parts of your application ---
module.exports = {
  query,
  pool, // Exporting the pool might be useful for graceful shutdown
};

// You might also want a function to end the pool gracefully on application shutdown
// For example, call this when your Node.js application is shutting down
// process.on('SIGINT', async () => {
//     console.log('Received SIGINT. Ending database pool...');
//     await pool.end();
//     console.log('Database pool ended.');
//     process.exit(0);
// });
