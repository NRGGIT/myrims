#!/usr/bin/env node

/**
 * CERIF Data Model Parser
 * 
 * This script generates SQL scripts for creating the PostgreSQL database schema
 * based on a simplified version of the CERIF data model.
 */

import fs from 'fs-extra';
import path from 'path';
import { fileURLToPath } from 'url';

// Get the directory name
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Paths
const OUTPUT_DIR = path.resolve(__dirname, '../init');
const SCHEMA_SQL_PATH = path.resolve(OUTPUT_DIR, '01-schema.sql');
const ROLES_SQL_PATH = path.resolve(OUTPUT_DIR, '02-roles.sql');
const SAMPLE_DATA_SQL_PATH = path.resolve(OUTPUT_DIR, '03-sample-data.sql');

// Ensure output directory exists
fs.ensureDirSync(OUTPUT_DIR);

// Main function
async function generateCerifModel() {
  try {
    console.log('Generating CERIF model SQL scripts...');
    
    // Generate SQL scripts
    await generateSchemaSQL();
    await generateRolesSQL();
    await generateSampleDataSQL();
    
    console.log('SQL scripts generated successfully!');
  } catch (error) {
    console.error('Error generating CERIF model:', error);
    process.exit(1);
  }
}

// Generate schema SQL
async function generateSchemaSQL() {
  console.log('Generating schema SQL...');
  
  // Define entities and relationships
  const entities = defineCerifEntities();
  const relationships = defineCerifRelationships();
  
  // Generate SQL for creating tables and relationships
  let sql = `-- CERIF Data Model Schema
-- Generated on ${new Date().toISOString()}
-- Based on CERIF 1.6.1 Full Data Model

-- Create schema
CREATE SCHEMA IF NOT EXISTS cerif;

-- Set search path
SET search_path TO cerif, public;

-- Enable row-level security
ALTER DATABASE rims_db SET row_level_security = on;

`;

  // Add SQL for creating tables
  sql += generateTablesSQL(entities);
  
  // Add SQL for creating relationships
  sql += generateRelationshipsSQL(relationships);
  
  // Write SQL to file
  await fs.writeFile(SCHEMA_SQL_PATH, sql);
  console.log(`Schema SQL written to ${SCHEMA_SQL_PATH}`);
}

// Define CERIF entities
function defineCerifEntities() {
  return [
    {
      name: 'Person',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'family_names', type: 'TEXT', isNullable: false },
        { name: 'given_names', type: 'TEXT', isNullable: false },
        { name: 'birth_date', type: 'DATE', isNullable: true },
        { name: 'gender', type: 'TEXT', isNullable: true }
      ]
    },
    {
      name: 'Organisation_Unit',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'name', type: 'TEXT', isNullable: false },
        { name: 'acronym', type: 'TEXT', isNullable: true },
        { name: 'type', type: 'TEXT', isNullable: true }
      ]
    },
    {
      name: 'Project',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'title', type: 'TEXT', isNullable: false },
        { name: 'acronym', type: 'TEXT', isNullable: true },
        { name: 'start_date', type: 'DATE', isNullable: true },
        { name: 'end_date', type: 'DATE', isNullable: true },
        { name: 'status', type: 'TEXT', isNullable: true },
        { name: 'abstract', type: 'TEXT', isNullable: true }
      ]
    },
    {
      name: 'Funding',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'amount', type: 'DECIMAL(15,2)', isNullable: false },
        { name: 'currency', type: 'TEXT', isNullable: false },
        { name: 'start_date', type: 'DATE', isNullable: true },
        { name: 'end_date', type: 'DATE', isNullable: true },
        { name: 'funding_type', type: 'TEXT', isNullable: true }
      ]
    },
    {
      name: 'Document',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'title', type: 'TEXT', isNullable: false },
        { name: 'abstract', type: 'TEXT', isNullable: true },
        { name: 'publication_date', type: 'DATE', isNullable: true },
        { name: 'document_type', type: 'TEXT', isNullable: true },
        { name: 'doi', type: 'TEXT', isNullable: true }
      ]
    },
    {
      name: 'Event',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'name', type: 'TEXT', isNullable: false },
        { name: 'start_date', type: 'DATE', isNullable: true },
        { name: 'end_date', type: 'DATE', isNullable: true },
        { name: 'location', type: 'TEXT', isNullable: true },
        { name: 'event_type', type: 'TEXT', isNullable: true }
      ]
    },
    {
      name: 'Contribution',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'person_id', type: 'UUID', isNullable: false },
        { name: 'role', type: 'TEXT', isNullable: false },
        { name: 'start_date', type: 'DATE', isNullable: true },
        { name: 'end_date', type: 'DATE', isNullable: true }
      ]
    },
    {
      name: 'Project_Funding',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'project_id', type: 'UUID', isNullable: false },
        { name: 'funding_id', type: 'UUID', isNullable: false }
      ]
    },
    {
      name: 'Project_Document',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'project_id', type: 'UUID', isNullable: false },
        { name: 'document_id', type: 'UUID', isNullable: false }
      ]
    },
    {
      name: 'Document_Contribution',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'document_id', type: 'UUID', isNullable: false },
        { name: 'contribution_id', type: 'UUID', isNullable: false }
      ]
    },
    {
      name: 'Project_Contribution',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'project_id', type: 'UUID', isNullable: false },
        { name: 'contribution_id', type: 'UUID', isNullable: false }
      ]
    },
    {
      name: 'Person_Organisation',
      attributes: [
        { name: 'id', type: 'UUID', isPrimaryKey: true },
        { name: 'created', type: 'TIMESTAMP', isNullable: false },
        { name: 'modified', type: 'TIMESTAMP', isNullable: false },
        { name: 'person_id', type: 'UUID', isNullable: false },
        { name: 'organisation_id', type: 'UUID', isNullable: false },
        { name: 'role', type: 'TEXT', isNullable: false },
        { name: 'start_date', type: 'DATE', isNullable: true },
        { name: 'end_date', type: 'DATE', isNullable: true }
      ]
    }
  ];
}

// Define CERIF relationships
function defineCerifRelationships() {
  return [
    {
      name: 'Person_Organisation_FK',
      sourceTable: 'Person_Organisation',
      sourceColumn: 'person_id',
      targetTable: 'Person',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Person_Organisation_FK2',
      sourceTable: 'Person_Organisation',
      sourceColumn: 'organisation_id',
      targetTable: 'Organisation_Unit',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Contribution_Person_FK',
      sourceTable: 'Contribution',
      sourceColumn: 'person_id',
      targetTable: 'Person',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Project_Funding_FK1',
      sourceTable: 'Project_Funding',
      sourceColumn: 'project_id',
      targetTable: 'Project',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Project_Funding_FK2',
      sourceTable: 'Project_Funding',
      sourceColumn: 'funding_id',
      targetTable: 'Funding',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Project_Document_FK1',
      sourceTable: 'Project_Document',
      sourceColumn: 'project_id',
      targetTable: 'Project',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Project_Document_FK2',
      sourceTable: 'Project_Document',
      sourceColumn: 'document_id',
      targetTable: 'Document',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Document_Contribution_FK1',
      sourceTable: 'Document_Contribution',
      sourceColumn: 'document_id',
      targetTable: 'Document',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Document_Contribution_FK2',
      sourceTable: 'Document_Contribution',
      sourceColumn: 'contribution_id',
      targetTable: 'Contribution',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Project_Contribution_FK1',
      sourceTable: 'Project_Contribution',
      sourceColumn: 'project_id',
      targetTable: 'Project',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    },
    {
      name: 'Project_Contribution_FK2',
      sourceTable: 'Project_Contribution',
      sourceColumn: 'contribution_id',
      targetTable: 'Contribution',
      targetColumn: 'id',
      type: 'FOREIGN KEY'
    }
  ];
}

// Generate SQL for creating tables
function generateTablesSQL(entities) {
  let sql = '';
  
  for (const entity of entities) {
    sql += `-- Table: ${entity.name}\n`;
    sql += `CREATE TABLE IF NOT EXISTS ${entity.name} (\n`;
    
    // Add columns
    const columns = entity.attributes.map(attr => {
      let column = `  ${attr.name} ${attr.type}`;
      if (attr.isPrimaryKey) {
        column += ' PRIMARY KEY';
      }
      if (!attr.isNullable) {
        column += ' NOT NULL';
      }
      return column;
    });
    
    sql += columns.join(',\n');
    sql += '\n);\n\n';
    
    // Add comments
    sql += `COMMENT ON TABLE ${entity.name} IS 'CERIF entity: ${entity.name}';\n\n`;
  }
  
  return sql;
}

// Generate SQL for creating relationships
function generateRelationshipsSQL(relationships) {
  let sql = '';
  
  for (const rel of relationships) {
    sql += `-- Relationship: ${rel.name}\n`;
    sql += `ALTER TABLE ${rel.sourceTable} ADD CONSTRAINT ${rel.name}\n`;
    sql += `  ${rel.type} (${rel.sourceColumn}) REFERENCES ${rel.targetTable} (${rel.targetColumn});\n\n`;
  }
  
  return sql;
}

// Generate roles SQL
async function generateRolesSQL() {
  console.log('Generating roles SQL...');
  
  const sql = `-- CERIF Data Model Roles
-- Generated on ${new Date().toISOString()}

-- Create roles
CREATE ROLE principal_investigator;
CREATE ROLE researcher;
CREATE ROLE research_administrator;
CREATE ROLE financial_officer;
CREATE ROLE grant_officer;
CREATE ROLE institutional_executive;
CREATE ROLE library_manager;
CREATE ROLE system_administrator;
CREATE ROLE external_collaborator;

-- Set search path
SET search_path TO cerif, public;

-- Principal Investigator permissions
GRANT SELECT ON ALL TABLES IN SCHEMA cerif TO principal_investigator;
GRANT INSERT, UPDATE, DELETE ON Person, Project, Document, Contribution, Project_Contribution, Document_Contribution TO principal_investigator;

-- Researcher permissions
GRANT SELECT ON ALL TABLES IN SCHEMA cerif TO researcher;
GRANT INSERT, UPDATE, DELETE ON Person, Document, Contribution, Document_Contribution TO researcher;

-- Research Administrator permissions
GRANT SELECT ON ALL TABLES IN SCHEMA cerif TO research_administrator;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA cerif TO research_administrator;

-- Financial Officer permissions
GRANT SELECT ON ALL TABLES IN SCHEMA cerif TO financial_officer;
GRANT INSERT, UPDATE, DELETE ON Funding, Project_Funding TO financial_officer;

-- Grant Officer permissions
GRANT SELECT ON ALL TABLES IN SCHEMA cerif TO grant_officer;
GRANT INSERT, UPDATE, DELETE ON Funding, Project_Funding TO grant_officer;

-- Institutional Executive permissions
GRANT SELECT ON ALL TABLES IN SCHEMA cerif TO institutional_executive;

-- Library Manager permissions
GRANT SELECT ON ALL TABLES IN SCHEMA cerif TO library_manager;
GRANT INSERT, UPDATE, DELETE ON Document, Document_Contribution TO library_manager;

-- System Administrator permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cerif TO system_administrator;

-- External Collaborator permissions
GRANT SELECT ON Person, Organisation_Unit, Project, Document, Event TO external_collaborator;

-- Row-level security policies
-- These are simplified examples and would need to be expanded for a real implementation

-- Person policy
CREATE POLICY person_policy ON Person
  USING (
    CASE 
      WHEN current_user = 'system_administrator' THEN true
      WHEN current_user = 'research_administrator' THEN true
      WHEN current_user = 'principal_investigator' AND id IN (SELECT person_id FROM Contribution WHERE role = 'Principal Investigator') THEN true
      WHEN current_user = 'researcher' AND id IN (SELECT person_id FROM Contribution) THEN true
      ELSE id IN (SELECT person_id FROM Person WHERE family_names = 'Public')
    END
  );

-- Project policy
CREATE POLICY project_policy ON Project
  USING (
    CASE 
      WHEN current_user = 'system_administrator' THEN true
      WHEN current_user = 'research_administrator' THEN true
      WHEN current_user = 'financial_officer' THEN true
      WHEN current_user = 'grant_officer' THEN true
      WHEN current_user = 'principal_investigator' AND id IN (
        SELECT project_id FROM Project_Contribution 
        JOIN Contribution ON Project_Contribution.contribution_id = Contribution.id
        WHERE Contribution.role = 'Principal Investigator'
      ) THEN true
      ELSE status = 'Public'
    END
  );

-- Enable row-level security on tables
ALTER TABLE Person ENABLE ROW LEVEL SECURITY;
ALTER TABLE Project ENABLE ROW LEVEL SECURITY;
ALTER TABLE Document ENABLE ROW LEVEL SECURITY;
ALTER TABLE Funding ENABLE ROW LEVEL SECURITY;
`;
  
  await fs.writeFile(ROLES_SQL_PATH, sql);
  console.log(`Roles SQL written to ${ROLES_SQL_PATH}`);
}

// Generate sample data SQL
async function generateSampleDataSQL() {
  console.log('Generating sample data SQL...');
  
  const sql = `-- CERIF Data Model Sample Data
-- Generated on ${new Date().toISOString()}

-- Set search path
SET search_path TO cerif, public;

-- Sample data for Person
INSERT INTO Person (id, created, modified, family_names, given_names, birth_date, gender)
VALUES
  ('11111111-1111-1111-1111-111111111111', NOW(), NOW(), 'Smith', 'John', '1980-01-01', 'Male'),
  ('22222222-2222-2222-2222-222222222222', NOW(), NOW(), 'Johnson', 'Emily', '1985-05-15', 'Female'),
  ('33333333-3333-3333-3333-333333333333', NOW(), NOW(), 'Williams', 'Michael', '1975-11-30', 'Male'),
  ('44444444-4444-4444-4444-444444444444', NOW(), NOW(), 'Brown', 'Sarah', '1990-08-22', 'Female'),
  ('55555555-5555-5555-5555-555555555555', NOW(), NOW(), 'Jones', 'David', '1982-03-10', 'Male');

-- Sample data for Organisation_Unit
INSERT INTO Organisation_Unit (id, created, modified, name, acronym, type)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NOW(), NOW(), 'University of Science', 'UoS', 'University'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NOW(), NOW(), 'Department of Computer Science', 'DCS', 'Department'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', NOW(), NOW(), 'Research Institute', 'RI', 'Institute'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', NOW(), NOW(), 'Funding Agency', 'FA', 'Agency'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', NOW(), NOW(), 'Industry Partner', 'IP', 'Company');

-- Sample data for Project
INSERT INTO Project (id, created, modified, title, acronym, start_date, end_date, status, abstract)
VALUES
  ('11111111-aaaa-1111-aaaa-111111111111', NOW(), NOW(), 'Advanced Research Project', 'ARP', '2023-01-01', '2025-12-31', 'Active', 'This project aims to advance research in the field.'),
  ('22222222-bbbb-2222-bbbb-222222222222', NOW(), NOW(), 'Innovation Development', 'ID', '2022-06-01', '2024-05-31', 'Active', 'Developing innovative solutions for industry problems.'),
  ('33333333-cccc-3333-cccc-333333333333', NOW(), NOW(), 'Scientific Exploration', 'SE', '2021-09-01', '2023-08-31', 'Completed', 'Exploring new scientific frontiers.'),
  ('44444444-dddd-4444-dddd-444444444444', NOW(), NOW(), 'Technology Transfer', 'TT', '2024-01-01', '2026-12-31', 'Planned', 'Transferring technology from academia to industry.'),
  ('55555555-eeee-5555-eeee-555555555555', NOW(), NOW(), 'Collaborative Research', 'CR', '2023-03-01', '2025-02-28', 'Active', 'Collaborative research between multiple institutions.');
`;
  
  await fs.writeFile(SAMPLE_DATA_SQL_PATH, sql);
  console.log(`Sample data SQL written to ${SAMPLE_DATA_SQL_PATH}`);
}

// Run the script
generateCerifModel().catch(console.error);
