-- CERIF Data Model Schema
-- Generated on 2025-04-04T08:26:24.174Z
-- Based on CERIF 1.6.1 Full Data Model

-- Create schema
CREATE SCHEMA IF NOT EXISTS cerif;

-- Set search path
SET search_path TO cerif, public;

-- Enable row-level security
ALTER DATABASE rims_db SET row_level_security = on;

-- Table: Person
CREATE TABLE IF NOT EXISTS Person (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  family_names TEXT NOT NULL,
  given_names TEXT NOT NULL,
  birth_date DATE,
  gender TEXT
);

COMMENT ON TABLE Person IS 'CERIF entity: Person';

-- Table: Organisation_Unit
CREATE TABLE IF NOT EXISTS Organisation_Unit (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  name TEXT NOT NULL,
  acronym TEXT,
  type TEXT
);

COMMENT ON TABLE Organisation_Unit IS 'CERIF entity: Organisation_Unit';

-- Table: Project
CREATE TABLE IF NOT EXISTS Project (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  title TEXT NOT NULL,
  acronym TEXT,
  start_date DATE,
  end_date DATE,
  status TEXT,
  abstract TEXT
);

COMMENT ON TABLE Project IS 'CERIF entity: Project';

-- Table: Funding
CREATE TABLE IF NOT EXISTS Funding (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  currency TEXT NOT NULL,
  start_date DATE,
  end_date DATE,
  funding_type TEXT
);

COMMENT ON TABLE Funding IS 'CERIF entity: Funding';

-- Table: Document
CREATE TABLE IF NOT EXISTS Document (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  title TEXT NOT NULL,
  abstract TEXT,
  publication_date DATE,
  document_type TEXT,
  doi TEXT
);

COMMENT ON TABLE Document IS 'CERIF entity: Document';

-- Table: Event
CREATE TABLE IF NOT EXISTS Event (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  name TEXT NOT NULL,
  start_date DATE,
  end_date DATE,
  location TEXT,
  event_type TEXT
);

COMMENT ON TABLE Event IS 'CERIF entity: Event';

-- Table: Contribution
CREATE TABLE IF NOT EXISTS Contribution (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  person_id UUID NOT NULL,
  role TEXT NOT NULL,
  start_date DATE,
  end_date DATE
);

COMMENT ON TABLE Contribution IS 'CERIF entity: Contribution';

-- Table: Project_Funding
CREATE TABLE IF NOT EXISTS Project_Funding (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  project_id UUID NOT NULL,
  funding_id UUID NOT NULL
);

COMMENT ON TABLE Project_Funding IS 'CERIF entity: Project_Funding';

-- Table: Project_Document
CREATE TABLE IF NOT EXISTS Project_Document (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  project_id UUID NOT NULL,
  document_id UUID NOT NULL
);

COMMENT ON TABLE Project_Document IS 'CERIF entity: Project_Document';

-- Table: Document_Contribution
CREATE TABLE IF NOT EXISTS Document_Contribution (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  document_id UUID NOT NULL,
  contribution_id UUID NOT NULL
);

COMMENT ON TABLE Document_Contribution IS 'CERIF entity: Document_Contribution';

-- Table: Project_Contribution
CREATE TABLE IF NOT EXISTS Project_Contribution (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  project_id UUID NOT NULL,
  contribution_id UUID NOT NULL
);

COMMENT ON TABLE Project_Contribution IS 'CERIF entity: Project_Contribution';

-- Table: Person_Organisation
CREATE TABLE IF NOT EXISTS Person_Organisation (
  id UUID PRIMARY KEY NOT NULL,
  created TIMESTAMP NOT NULL,
  modified TIMESTAMP NOT NULL,
  person_id UUID NOT NULL,
  organisation_id UUID NOT NULL,
  role TEXT NOT NULL,
  start_date DATE,
  end_date DATE
);

COMMENT ON TABLE Person_Organisation IS 'CERIF entity: Person_Organisation';

-- Relationship: Person_Organisation_FK
ALTER TABLE Person_Organisation ADD CONSTRAINT Person_Organisation_FK
  FOREIGN KEY (person_id) REFERENCES Person (id);

-- Relationship: Person_Organisation_FK2
ALTER TABLE Person_Organisation ADD CONSTRAINT Person_Organisation_FK2
  FOREIGN KEY (organisation_id) REFERENCES Organisation_Unit (id);

-- Relationship: Contribution_Person_FK
ALTER TABLE Contribution ADD CONSTRAINT Contribution_Person_FK
  FOREIGN KEY (person_id) REFERENCES Person (id);

-- Relationship: Project_Funding_FK1
ALTER TABLE Project_Funding ADD CONSTRAINT Project_Funding_FK1
  FOREIGN KEY (project_id) REFERENCES Project (id);

-- Relationship: Project_Funding_FK2
ALTER TABLE Project_Funding ADD CONSTRAINT Project_Funding_FK2
  FOREIGN KEY (funding_id) REFERENCES Funding (id);

-- Relationship: Project_Document_FK1
ALTER TABLE Project_Document ADD CONSTRAINT Project_Document_FK1
  FOREIGN KEY (project_id) REFERENCES Project (id);

-- Relationship: Project_Document_FK2
ALTER TABLE Project_Document ADD CONSTRAINT Project_Document_FK2
  FOREIGN KEY (document_id) REFERENCES Document (id);

-- Relationship: Document_Contribution_FK1
ALTER TABLE Document_Contribution ADD CONSTRAINT Document_Contribution_FK1
  FOREIGN KEY (document_id) REFERENCES Document (id);

-- Relationship: Document_Contribution_FK2
ALTER TABLE Document_Contribution ADD CONSTRAINT Document_Contribution_FK2
  FOREIGN KEY (contribution_id) REFERENCES Contribution (id);

-- Relationship: Project_Contribution_FK1
ALTER TABLE Project_Contribution ADD CONSTRAINT Project_Contribution_FK1
  FOREIGN KEY (project_id) REFERENCES Project (id);

-- Relationship: Project_Contribution_FK2
ALTER TABLE Project_Contribution ADD CONSTRAINT Project_Contribution_FK2
  FOREIGN KEY (contribution_id) REFERENCES Contribution (id);

