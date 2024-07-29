use database failsafe_demo;

--this will fail, because temp table exists only in a db session it was created in.
select * from customer_temp;

create transient table nation_tra as
select * from snowflake_sample_data.tpch_sf1.nation;

select count(*) from nation_tra;

select current_timestamp;
-- 2024-07-22 02:16:47.337 -0700

update nation_tra set n_comment = NULL;

--we didn't get NULL values. Time travel with AT worked on th etemp table
select distinct n_comment from nation_tra
at(timestamp => '2024-07-22 02:16:47.337 -0700'::timestamp_ltz);