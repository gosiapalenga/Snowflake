create database failsafe_demo;
use database failsafe_demo;

create temporary table customer_temp as
select * from snowflake_sample_data.tpch_sf1.customer;

select count(*) from customer_temp;

select current_timestamp;
-- 2024-07-22 02:10:30.220 -0700

update customer_temp set c_name = NULL;

--we didn't get NUL values. Time travel with AT worked on th etemp table
select distinct c_name from customer_temp
at(timestamp => '2024-07-22 02:10:30.220 -0700'::timestamp_ltz);


-- test transient table availability in a new session.
use database failsafe_demo;
select * from nation_tra;