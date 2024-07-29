-- delivery_clean_tbl

use role sysadmin;
use warehouse compute_wh;
use schema cricket.clean;

-- stage 1
-- extract team_name from innings
select 
    info:match_type_number::int as match_type_number,
    i.value:team::text as team_name,             -- value is a column name
    i.*
from cricket.raw.match_raw_tbl,
lateral flatten (input => innings) i
where match_type_number = 4672;

-- stage 2
-- extract overs
select 
    info:match_type_number::int as match_type_number,
    i.value:team::text as team_name,             -- value is a column name
    o.value:over::int as over,
    o.*
from cricket.raw.match_raw_tbl,
lateral flatten (input => innings) i,
lateral flatten (input => i.value:overs) o,
where match_type_number = 4672;


-- stage 3
-- extract deliveries values
select 
    info:match_type_number::int as match_type_number,
    i.value:team::text as team_name,             -- value is a column name
    o.value:over::int as over,
    d.value:bowler::text as bowler,
    d.value:batter::text as batter,
    d.value:non_striker::text as non_striker,
    d.value:runs.batter::text as runs,
    d.value:runs.extras::text as extras,
    d.value:runs.total::text as total
from cricket.raw.match_raw_tbl,
lateral flatten (input => innings) i,
lateral flatten (input => i.value:overs) o,
lateral flatten (input => o.value:deliveries) d
where match_type_number = 4672;


-- stage 4
-- extraxt 'extra', 'wickets' elements which appears only a few times
select 
    info:match_type_number::int as match_type_number,
    i.value:team::text as team_name,             -- value is a column name
    o.value:over::int as over,
    d.value:bowler::text as bowler,
    d.value:batter::text as batter,
    d.value:non_striker::text as non_striker,
    d.value:runs.batter::text as runs,
    d.value:runs.extras::text as extras,
    d.value:runs.total::text as total,
    e.key::text as extra_type,
    e.value::number as extra_runs,
    w.value:player_out::text as player_out,
    w.value:kind::text as player_out_kind,
    w.value:fielders::variant as player_out_fielders
    --e.*
from cricket.raw.match_raw_tbl,
lateral flatten (input => innings) i,
lateral flatten (input => i.value:overs) o,
lateral flatten (input => o.value:deliveries) d,
lateral flatten (input => d.value:extras, outer => True) e,   -- if outer isn't included, deliveries without extras (null values) will be excluded. Not all deliveriess have extras.
lateral flatten (input => d.value:wickets, outer => True) w
where match_type_number = 4676;


-- stage 5
-- create delivery_clean_tbl
create or replace transient table cricket.clean.delivery_clean_tbl as
select 
    info:match_type_number::int as match_type_number,
    i.value:team::text as team_name,             -- value is a column name
    o.value:over::int as over,
    d.value:bowler::text as bowler,
    d.value:batter::text as batter,
    d.value:non_striker::text as non_striker,
    d.value:runs.batter::text as runs,
    d.value:runs.extras::text as extras,
    d.value:runs.total::text as total,
    e.key::text as extra_type,
    e.value::number as extra_runs,
    w.value:player_out::text as player_out,
    w.value:kind::text as player_out_kind,
    w.value:fielders::variant as player_out_fielders
from cricket.raw.match_raw_tbl,
lateral flatten (input => innings) i,
lateral flatten (input => i.value:overs) o,
lateral flatten (input => o.value:deliveries) d,
lateral flatten (input => d.value:extras, outer => True) e,   -- if outer isn't included, deliveries without extras (null values) will be excluded. Not all deliveriess have extras.
lateral flatten (input => d.value:wickets, outer => True) w;


select distinct match_type_number
from cricket.clean.delivery_clean_tbl;


desc table cricket.clean.delivery_clean_tbl;

alter table cricket.clean.delivery_clean_tbl
modify column match_type_number set not null;

alter table cricket.clean.delivery_clean_tbl
modify column team_name set not null;

alter table cricket.clean.delivery_clean_tbl
modify column over set not null;

alter table cricket.clean.delivery_clean_tbl
modify column bowler set not null;

alter table cricket.clean.delivery_clean_tbl
modify column batter set not null;

alter table cricket.clean.delivery_clean_tbl
modify column NON_STRIKER set not null;


-- add fk
alter table cricket.clean.delivery_clean_tbl
add constraint fk_delivery_match_id
foreign key (match_type_number)
references cricket.clean.match_detail_clean (match_type_number);

select get_ddl('table', 'cricket.clean.delivery_clean_tbl');