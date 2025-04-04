-- CERIF Data Model Roles
-- Generated on 2025-04-04T08:26:24.175Z

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
