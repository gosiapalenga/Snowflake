create or replace database test_cloning;
use database test_cloning;


--physical copy of the table
CREATE TABLE test_cloning.public.CUSTOMER AS
SELECT * FROM snowflake_sample_data.tpch_sf1000.customer;

SELECT COUNT(*) FROM CUSTOMER:

-- clone the customer table (metadata copy, repointing to the existing micro partitions)
CREATE TABLE CUSTOMER_COPY CLONE CUSTOMER;

SELECT COUNT(*) FROM CUSTOMER_COPY;

--update the customer_copy table
UPDATE CUSTOMER_COPY SET C_MKTSEGMENT = 'AUTO'
WHERE MKTSEGMENT = 'AUTOMOBILE';


--see the applied changes
SELECT DISTINCT C_MKTSEGMENT FROM CUSTOMER;
SELECT DISTINCT C_MKTSEGMENT FROM CUSTOMER_COPY;