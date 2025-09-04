const { Pool } = require("pg")

const pool = new Pool({
  user: "postgres", // username PostgreSQL
  host: "localhost",
  database: "my_portfolio_app", // nama database
  password: "980213", // password PostgreSQL
  port: 5432,
})

module.exports = pool
