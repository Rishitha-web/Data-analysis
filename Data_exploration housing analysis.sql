-- Using database--
use housing_analysis;
-- to know the tables in the data base--
show tables;
-- to describe table like data type/null vales/unique value--
desc april_2025;
-- to display table values--
select * from april_2025;
-- To count the distinct/unique values --
select count(distinct(suburb)) from april_2025;
-- To change the date format--
alter table april_2025 modify column bond_act_date DATE;
-- To change data format to dd/mm/yyy default value yyyy-mm-dd--
UPDATE april_2025
SET bond_act_date = STR_TO_DATE(bond_act_date, '%d/%m/%Y')
WHERE april_2025.state = 'tasmania';
-- To find the highest bond amount for each suburb --
SELECT suburb,avg(bond_amount)
FROM april_2025
GROUP BY suburb;
-- To find sum bond amount --
select sum(bond_amount)  from april_2025;
-- To find top 5 bond amounts --
select suburb,bond_amount
from april_2025
order by bond_amount desc limit 5;


