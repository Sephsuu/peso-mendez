// import mysql from 'mysql2/promise';
// import dotenv from 'dotenv';

// dotenv.config();

// const pool = mysql.createPool({
//   host: process.env.DB_HOST,
//   user: process.env.DB_USER,
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
//   waitForConnections: true,
//   connectionLimit: 10,
//   queueLimit: 0
// });

// export default pool;

import mysql from "mysql2/promise";

if (process.env.NODE_ENV !== "production") {
  const dotenv = await import("dotenv");
  dotenv.default.config();
}

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 25060),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,

  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,

  ssl: { rejectUnauthorized: false },
});

export default pool;