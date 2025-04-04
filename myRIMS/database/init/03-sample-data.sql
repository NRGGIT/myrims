-- CERIF Data Model Sample Data
-- Generated on 2025-04-04T08:26:24.176Z

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
