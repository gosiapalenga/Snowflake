USE WAREHOUSE compute_wh;
CREATE OR REPLACE DATABASE data_quality;

CREATE TABLE ORDERS AS
SELECT * FROM snowflake_sample_data.tpch_sf1.orders;

CREATE TABLE REGION AS
SELECT * FROM snowflake_sample_data.tpch_sf1.region;

SELECT COUNT(*) FROM orders;

SELECT * FROM orders
LIMIT 10;


-- COMPLETNESS - NULL VALUE CHECK
SELECT 'ORDERS' AS table_name,
       'O_ORDERDATE' AS attribute,
       SUM(CASE WHEN O_ORDERDATE IS NULL THEN 1 ELSE 0 END) AS count_null_values 
FROM ORDERS
UNION ALL
SELECT 'ORDERS' AS table_name,
       'O_CUSTKEY' AS attribute,
       SUM(CASE WHEN O_CUSTKEY IS NULL THEN 1 ELSE 0 END) AS count_null_values 
FROM ORDERS;



-- UNIQUENESS - CHECK FOR DUPLICATES
SELECT 'ORDERS' AS table_name,
       'O_ORDERKEY' AS attribute, 
       COUNT(O_ORDERKEY) as count_records,
       COUNT(DISTINCT O_ORDERKEY) as count_distinct_records,
       COUNT(O_ORDERKEY) - COUNT(DISTINCT O_ORDERKEY) as count_duplicates
FROM ORDERS;

SELECT O_ORDERKEY, COUNT(*) as total_count
FROM ORDERS
GROUP BY  O_ORDERKEY
HAVING total_count > 1;



-- RANGE CHECK
SELECT 'ORDERS' AS table_name,
       'O_SHIPPRIORITY' AS attribute,
       '0' as validity_rule,
       SUM(CASE WHEN O_SHIPPRIORITY = 0 THEN 1 ELSE 0 END) AS count_valid_values,
       SUM(CASE WHEN O_SHIPPRIORITY != 0 THEN 1 ELSE 0 END) AS count_invalid_values
FROM ORDERS;



-- CONSISTENCY - consistent names/values
SELECT * FROM REGION LIMIT 10;

SELECT R_NAME as distinct_value,
       COUNT(*) as distinct_value_count,
       'REGION' as table_name,
       'R_NAME' as attribute_name
FROM REGION
GROUP BY R_NAME;



-- DATA INTEGRITY - SOURCE AND TARGET DATA MATCH
SELECT 'REGION_DIM'  as table_name,
       'R_NAME'      as source_column,
       'REGION_FACT' as target_table,
       'R_NAME'      as target_column,
    (SELECT R_NAME FROM REGION
     EXCEPT
     SELECT R_NAME FROM REGION) as mismatch;
       

SELECT 'REGION_DIM'  as table_name,
       'R_NAME'      as source_column,
       'REGION_FACT' as target_table,
       'R_NAME'      as target_column,
    (SELECT R_NAME FROM REGION
     EXCEPT
     SELECT R_NAME FROM REGION) as mismatch;




















