#!/usr/bin/env node

/**
 * Test connection to the PostgreSQL database
 * 
 * This script tests the connection to the PostgreSQL database
 * and verifies that the CERIF schema exists.
 */

import pg from 'pg';
const { Client } = pg;

// Database connection configuration
const config = {
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'rims_db',
  user: process.env.DB_USER || 'rims_admin',
  password: process.env.DB_PASSWORD || 'rims_password'
};

// Test the connection
async function testConnection() {
  const client = new Client(config);
  
  try {
    console.log('Connecting to PostgreSQL database...');
    await client.connect();
    console.log('Connected to PostgreSQL database successfully!');
    
    console.log('Checking for CERIF schema...');
    const result = await client.query(`
      SELECT schema_name
      FROM information_schema.schemata
      WHERE schema_name = 'cerif'
    `);
    
    if (result.rows.length > 0) {
      console.log('CERIF schema exists!');
      
      // Check for some core tables
      const tablesResult = await client.query(`
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'cerif'
        AND table_name IN ('Person', 'Organisation_Unit', 'Project', 'Document', 'Funding')
      `);
      
      console.log(`Found ${tablesResult.rows.length} core tables in CERIF schema:`);
      tablesResult.rows.forEach(row => {
        console.log(`- ${row.table_name}`);
      });
      
      console.log('Database connection test completed successfully!');
    } else {
      console.error('CERIF schema does not exist!');
      process.exit(1);
    }
  } catch (error) {
    console.error('Error connecting to PostgreSQL database:', error);
    process.exit(1);
  } finally {
    await client.end();
  }
}

// Run the test
testConnection().catch(console.error);
