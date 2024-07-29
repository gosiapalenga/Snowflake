USE DATABASE dev_landing;
USE SCHEMA public;

CREATE TABLE LU_Airports
(
    airline_id Number,
    airline_description String
);

-- create internal stage, no location provided in an internal stage
-- PUT command is used to upload data from an on-premises system to an internal stage.
CREATE OR REPLACE STAGE LU_Airport_CSV_Stage
    FILE_FORMAT = (TYPE = csv FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

    
-- load the file into the internal stage using SnowSQL. Data gets encrypted and compressed.
USE DATABASE dev_landing;
PUT 'file:///C:/Users/go27s/OneDrive/Desktop/Courses/Snowflake/L_AIRPORT_ID.csv' @LU_Airport_CSV_Stage;

LIST @LU_Airport_CSV_Stage;

--copy the data to the table form the internal stage.
USE DATABASE dev_landing;
COPY INTO LU_AIRPORTS
    FROM @LU_Airport_CSV_Stage;


--validate
SELECT *
FROM LU_AIRPORTS
LIMIT 10;

--once the data has been loaded into a table, remove the internal stage to avoid storage fees.
REMOVE  @LU_Airport_CSV_Stage;