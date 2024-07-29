USE DATABASE dev_landing;
USE SCHEMA public;
 
CREATE TABLE LU_City_Market
(
City_Market_ID Number,
City_Market_Description String
);


-- We will use the table stage object, created and associated automatically with a table.

--use SnowSQL
USE DATABASE dev_landing;
PUT 'file:///C:/Users/go27s/OneDrive/Desktop/Courses/Snowflake/L_CITY_MARKET_ID.csv' @%LU_City_Market;


LIST @%LU_City_Market;

USE DATABASE dev_landing;
COPY INTO LU_City_Market
FROM @%LU_City_Market
FILE_FORMAT = (TYPE = csv FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM LU_City_Market
LIMIT 10;


-- clear the data in a table stage after it has been loaded
REMOVE @%LU_City_Market;