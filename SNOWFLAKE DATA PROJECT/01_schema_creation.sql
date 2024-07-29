-- STEP 1
-- LOAD DATA TO STAGE/LANDING LOCATION.


use role SYSADMIN;          -- select role
use warehouse compute_wh;   -- select compute

-- create a database Cricket and 4 schemas
create database if not exists cricket;
create or replace schema cricket.land;
create or replace schema cricket.raw;
create or replace schema cricket.clean;
create or replace schema cricket.consumption;

show schemas in database cricket;

-- change context
use schema cricket.land;

-- create json file format
create or replace file format cricket.land.my_json_format
    type = json
    null_if = ('\\n', 'null', '')
    strip_outer_array = true
    comment = 'JSON File Format with outer strip array flag True';


-- create an external stage for the data
create or replace stage cricket.land.my_stage;

-- manual loading files
-- click on MY_STAGE --> Enable Directory Table --> +Files --> provide path /cricket/json

-- using snowsql --> >put file:///path/cricket_data/*.json @my_stage/cricket/json/ parallel=50

-- get source files details
list @cricket.land.my_stage;


--validate the json files
select 
        t.$1:meta::variant as meta, 
        t.$1:info::variant as info, 
        t.$1:innings::array as innings, 
        metadata$filename as file_name,
        metadata$file_row_number int,
        metadata$file_content_key text,
        metadata$file_last_modified stg_modified_ts
from @my_stage/cricket/json/1384401.json (file_format => 'my_json_format') t;
        