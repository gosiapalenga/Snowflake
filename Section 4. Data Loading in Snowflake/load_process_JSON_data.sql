USE DATABASE dev_landing;
USE SCHEMA public;


--VARIANT is a special data type in Snowflake that can hold any data.
CREATE TABLE flight_data_json
(
json_data VARIANT
);


--create external stage pointing to the S3 bucket
CREATE OR REPLACE STAGE flights_json_stage
    url='s3://ca-flight-json-data-daily/2020/07/01/'
    file_format = (type = 'JSON');


LIST @flights_json_stage;


--parse the data and validate that the data is a valid JSON file.
SELECT PARSE_JSON($1)
FROM @flights_json_stage;

--load the data into the FLIGHT_DATA_JSON table from the external stage
USE DATABASE dev_landing;
COPY INTO flight_data_json
FROM @flights_json_stage;


--validate table
SELECT * FROM flight_data_json;

--extract data out of array
--1. select the flights array object and review the output.
SELECT json_data:flights FROM flight_data_json;


--Since flights is a JSON array, we can access elements of this array using a numerical value.
SELECT json_data:flights[0] FROM flight_data_json;


--access FL_DATE element
SELECT json_data:flights[0].FL_DATE 
FROM flight_data_json;


SELECT json_data:flights[0].FL_DATE,
    json_data:flights[0].OP_CARRIER_FL_NUM,
    json_data:flights[0].ORIGIN,
    json_data:flights[0].DESTINATION
FROM flight_data_json;


--sub-elements can be accessed through the . syntax
SELECT json_data:flights[0].FL_DATE,
    json_data:flights[0].OP_CARRIER_FL_NUM,
    json_data:flights[0].ORIGIN.ORIGIN_STATE_ABR,
    json_data:flights[0].ORIGIN.DEP_TIME,
    json_data:flights[0].DESTINATION.DEST_STATE_ABR,
    json_data:flights[0].DESTINATION.ARR_TIME
FROM flight_data_json;


--pivot the JSON data so that each element in the array becomes a row and the final data is tabular.
--FLATTEN function is used to convert the JSON array into row.
--LATERAL function takes as input an object of type VARIANT, OBJECT, or ARRAY and explodes that into rows
SELECT *
FROM flight_data_json, LATERAL FLATTEN( input => flight_data_json.json_data:flights );


--VALUE column contains the JSON for each row after the FLATTEN function has converted the array into multiple rows. 
--use the VALUE column to extract the individual value for each row.
SELECT
    value:FL_DATE,
    value:OP_CARRIER_FL_NUM,
    value:ORIGIN.ORIGIN_STATE_ABR,
    value:ORIGIN.DEP_TIME,
    value:DESTINATION.DEST_STATE_ABR,
    value:DESTINATION.ARR_TIME
FROM flight_data_json, LATERAL FLATTEN( input => flight_data_json.json_data:flights );


--set the data type of each column and name each column. You can also add additional columns as needed.
SELECT
    value:FL_DATE::Date AS Flight_Date,
    value:OP_CARRIER_FL_NUM::String AS Airline_Flight_Number,
    value:ORIGIN.ORIGIN_STATE_ABR::String AS Origin_State_Code,
    value:ORIGIN.DEP_TIME::Number AS Departure_Time,
    value:DESTINATION.DEST_STATE_ABR::String AS Dest_State_Code,
    value:DESTINATION.ARR_TIME::Number AS Arrival_Time
FROM flight_data_json, LATERAL FLATTEN( input => flight_data_json.json_data:flights );