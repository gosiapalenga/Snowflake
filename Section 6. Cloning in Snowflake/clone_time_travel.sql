CREATE OR REPLACE DATABASE test_timetravel_cloning;
USE DATABASE test_timetravel_cloning;

CREATE TABLE test_timetravel_cloning.public.CUSTOMER AS
SELECT * FROM snowflake_sample_data.tpch_sf10.customer;

SELECT COUNT(*) FROM customer;

SELECT CURRENT_TIMESTAMP;
--2024-07-23 05:45:45.129 -0700


UPDATE customer SET c_name = 'John Smith';


--clone table as it existed before a certain change
CREATE TABLE customer_copy CLONE customer BEFORE(TIMESTAMP => '2024-07-23 05:45:45.129 -0700'::timestamp_ltz);

--we have various values in customer_copy, not John Smith as in customer table.
SELECT DISTINCT c_name FROM customer_copy;
SELECT DISTINCT c_name FROM customer;
