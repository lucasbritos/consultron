const { Pool } = require('pg')

const pool = new Pool({
    host: (process.env.NODE_ENV=="production")? process.env.POSTGRES_HOST_PROD : process.env.POSTGRES_HOST_DEV ,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: "application",
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
  })

module.exports = {
  query: (text, params) => pool.query(text, params)
}