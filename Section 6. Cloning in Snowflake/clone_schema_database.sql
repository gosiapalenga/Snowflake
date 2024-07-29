CREATE DATABASE sample_data_db;
USE DATABASE sample_data_db;

-- create schema in sample_data_db to demonstrate schema cloning, create 3 tables inside that schema
CREATE SCHEMA sample_schema1;
USE SCHEMA sample_schema1;
CREATE TABLE customer AS SELECT * FROM snowflake_sample_data.tpch_sf1.customer;
CREATE TABLE nation AS SELECT * FROM snowflake_sample_data.tpch_sf1.nation;
CREATE TABLE region AS SELECT * FROM snowflake_sample_data.tpch_sf1.region;

--create second schema to demonstrate database cloning
CREATE SCHEMA sample_schema2;
USE SCHEMA sample_schema2;
CREATE TABLE date_dim AS SELECT * FROM snowflake_sample_data.tpcds_sf10tcl.date_dim;
CREATE TABLE store AS SELECT * FROM snowflake_sample_data.tpcds_sf10tcl.store;

--create a database to demonstrate schema cloning
CREATE DATABASE DEMO_SCHEMA_CLONING;
USE DATABASE DEMO_SCHEMA_CLONING;


--clone schema
CREATE SCHEMA my_sample_schema CLONE sample_data_db.sample_schema1;

--clone database
CREATE DATABASE demo_database_cloning CLONE sample_data_db;