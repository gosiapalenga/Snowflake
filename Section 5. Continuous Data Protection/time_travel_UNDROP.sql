USE DATABASE timetravel_demo;
CREATE TABLE customer
AS SELECT* FROM snowflake_sample_data.tpcds_sf10tcl.customer;

-- drop table
DROP TABLE STORE;
SELECT COUNT(*) FROM STORE;

UNDROP TABLE STORE;

SELECT COUNT(*) FROM STORE;

--drop database
DROP DATABASE timetravel_demo;

USE DATABASE timetravel_demo;

UNDROP DATABASE timetravel_demo;

USE DATABASE timetravel_demo;
SELECT COUNT(*) FROM STORE;
SELECT COUNT(*) FROM CUSTOMER;