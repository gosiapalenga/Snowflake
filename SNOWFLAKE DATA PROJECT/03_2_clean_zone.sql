-- player_clean_tbl


use role sysadmin;
use warehouse compute_wh;
use schema cricket.clean;

-- players table stages
-- extract players to see the format
select 
    info:match_type_number::int as match_type_number,
    info:players,  -- no data type because it has to be flattened
    info:teams     -- no data type because it has to be flattened
from cricket.raw.match_raw_tbl;


-- use LATERAL FLATTEN to split the element into rows. 
-- run query with p.* first to ket the Key column
-- Save the Key column as Country
select
    info:match_type_number::int as match_type_number,
    --p.*
    p.key::text as country
from cricket.raw.match_raw_tbl,
lateral flatten (input => info:players) p
where match_type_number = 4672;


-- extract players
-- first flatten players element p
-- secondly, get values from flattened p
select
    info:match_type_number::int as match_type_number,
    p.key::text as country,
    --team.*
    team.value::text as player_name
from cricket.raw.match_raw_tbl,
lateral flatten (input => info:players) p,
lateral flatten (input => p.value) team
where match_type_number = 4672;


-- create table for player
create or replace table cricket.clean.player_clean_tbl as
select
    info:match_type_number::int as match_type_number,
    p.key::text as country,
    team.value::text as player_name,

    stg_file_name,
    stg_file_row_number,
    stg_file_hashkey,
    STG_MODIFIED_TS
from cricket.raw.match_raw_tbl,
lateral flatten (input => info:players) p,
lateral flatten (input => p.value) team;


-- describe the table (fk relationship isn't displayed using desc)
desc table cricket.clean.player_clean_tbl;


select get_ddl('table', 'cricket.clean.player_clean_tbl');


-- add not null columns
alter table cricket.clean.player_clean_tbl
modify column match_type_number set not null;

alter table cricket.clean.player_clean_tbl
modify column country set not null;

alter table cricket.clean.player_clean_tbl
modify column player_name set not null;


-- first add pk to add fk
alter table cricket.clean.match_detail_clean
add constraint pk_match_type_number primary key (match_type_number)

-- add fk
alter table cricket.clean.player_clean_tbl
add constraint fk_match_id
foreign key (match_type_number)
references cricket.clean.match_detail_clean (match_type_number);