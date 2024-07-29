CREATE OR REPLACE database demo_sharing;
USE DATABASE demo_sharing;

CREATE TABLE prospects as
SELECT * FROM snowflake_sample_data.tpch_sf1.customer;


-- share can only be created by Account Admin
USE ROLE ACCOUNTADMIN;
CREATE SHARE shr_prospects;

-- grant USAGE on database and schema that contains the table
GRANT usage ON DATABASE demo_sharing TO SHARE shr_prospects;
GRANT usage ON SCHEMA demo_sharing.public TO SHARE shr_prospects;

GRANT SELECT ON TABLE demo_sharing.public.prospects TO SHARE shr_prospects;

-- add Consumer account
ALTER SHARE shr_prospects ADD ACCOUNT = <consumer_account_number>;

--------- LOG INTO THE CONSUMER ACCOUNT --------------------------

USE ROLE ACCOUNTADMIN;
CREATE DATABASE Marketing_RO FROM SHARE <provider_account_name>.shr_prospects;

SELECT * FROM Marketing_RO.public.prospects;
SELECT COUNT(*) FROM Marketing_RO.public.prospects;


-------- BACK IN PROVIDER'S ACCOUNT ------------------------------

-- IF DATA IS DELETED FROM THE PROVIDER'S TABLE, THE CHANGES WILL BE REFLECTED IN THE CONSUMER'S TABLE
USE DATABASE demo_sharing;
DELETE FROM prospects WHERE C_MKTSEGMENT = 'AUTOMOBILE';

SELECT COUNT(*) from prospects;