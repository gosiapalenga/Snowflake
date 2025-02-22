-- firts entry point for the data
CREATE DATABASE dev_landing;

-- copy of the data as it looks in the source
CREATE DATABASE dev_scr_image;

-- integration layer
CREATE DATABASE dev_integration;

--access layer
CREATE DATABASE dev_access;


USE DATABASE dev_landing;
USE SCHEMA public;

CREATE TABLE Flight_Details
(
Flight_Date Date,
Airline_Code String ,
Airline_DOT_ID Number,
Airline_IATA_Code String,
Airline_Tail_Number String,
Airline_Flight_Number String,
Origin_Airport_ID Number,
Origin_Airport_SEQ_ID Number,
Origin_City_Market_ID Number,
Origin_Airport_Code String,
Origin_State_Code String,
Origin_State_FIPS Number,
Origin_Airport_WAC Number,
Destintation_Airport_ID Number,
Destintation_Airport_SEQ_ID Number,
Destintation_City_Market_ID Number,
Destination_Airport_Code String,
Dest_State_Code String,
Dest_State_FIPS Number,
Dest_Airport_WAC Number,
Departure_Time Number,
Departure_Delay_Duration Number,
Departure_Taxi_Duration Number,
Departure_Wheels_Off_Time Number,
Arrival_Wheels_On_Time Number,
Arrival_Taxi_Duration Number,
Arrival_Time Number,
Arrival_Delay Number,
Flight_Cancelled_Indicator String,
Flight_Cancellation_Code String,
Flight_Diverted_Indicator String,
Flight_Total_Duration Number,
Flight_In_Air_Duration Number,
Number_Of_Flights Number,
Total_Distance Number,
Carrier_Delay_Duration Number,
Weather_Delay_Duration Number,
NAS_Delay_Duration Number,
Security_Delay_Duration Number,
Late_Aircraft_Delay_Duration Number
);


-- create external stage
CREATE OR REPLACE STAGE flights_stage
    url = 's3://ca-flight-data-daily/2020/06/01'
    file_format = (type = 'CSV' field_delimiter =',' field_optionally_enclosed_by = '"' skip_header = 1);

    
-- get source file details
LIST @flights_stage;


-- inspect the loaded file
SELECT $1, $2, $3 from @flights_stage


-- copy data from stage object to the flight_details table
USE DATABASE dev_landing;
COPY INTO FLIGHT_DETAILS
    FROM @flights_stage
    PATTERN = '.*[.]csv';


-- validate data
SELECT COUNT(*)
FROM FLIGHT_DETAILS;

SELECT * 
FROM FLIGHT_DETAILS
LIMIT 10;
