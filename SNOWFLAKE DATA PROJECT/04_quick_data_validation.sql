use role sysadmin;
use warehouse compute_wh;
use schema cricket.clean;


select * from cricket.clean.match_detail_clean
where match_type_number = 4686;


-- https://www.espncricinfo.com/series/icc-cricket-world-cup-2023-24-1367856/india-vs-england-29th-match-1384420/live-cricket-score
select
    team_name,
    batter,
    sum(runs)
from 
    delivery_clean_tbl
where match_type_number = 4686
group by team_name, batter
order by 1,2,3 desc;


select 
    team_name,
    sum(runs) + sum(extra_runs)
from
    delivery_clean_tbl
where match_type_number = 4686
group by team_name
order by 1,2 desc;