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
-- avg rent of each suburb where dwelling type is seperate house--
SELECT suburb, AVG(weekly_rent) AS avg_rent
FROM april_2025
WHERE dwelling_type = 'separate house'
group by suburb;
-- To write in cte same as above --
with cte as (SELECT suburb, AVG(weekly_rent) AS avg_rent
FROM april_2025
WHERE dwelling_type = 'separate house'
group by suburb)
select a.* , c.avg_rent from april_2025 a left join cte c on a.suburb=c.suburb
where a.dwelling_type='separate house';
-- To display values which are not no fixed period length tenancy --
select * from april_2025
where length_tenancy != 'no fixed period';
-- To get values of highest suburn avg weekly rent--
SELECT suburb, AVG(weekly_rent)
FROM april_2025
GROUP BY suburb
ORDER BY avg(weekly_rent) DESC
LIMIT 1;
-- To display suburb av grent >350 and num of rooms more than 2 --
SELECT suburb, AVG(weekly_rent), num_rooms
FROM april_2025
WHERE num_rooms > 2
GROUP BY suburb , num_rooms
HAVING AVG(weekly_rent) > 350;
-- Print suburb where suburb weekly rent is greater than over all avg weekly rent --(sub query)
select suburb, avg(weekly_rent) from april_2025
GROUP BY suburb 
HAVING avg(weekly_rent) > (select avg(weekly_rent) from april_2025)
ORDER BY SUBURB DESC
LIMIT 10;
-- Print max length tenancy for each suburb --
select suburb, max(length_tenancy) from april_2025
Group by suburb
order by max(length_tenancy) desc; 
-- Print max bond amount along with the suburb--
select suburb, max(bond_amount) from april_2025
group by suburb
order by max(bond_amount) desc
limit 1;
-- To get max value--
select bond_amount, suburb from april_2025
order by bond_amount desc;
-- Print rank for each suburb according to bond amount--
select suburb, bond_amount, rank() 
over(partition by suburb order by bond_amount desc) as tent_length
from april_2025;
-- To find the row number--
select suburb, bond_amount, row_number() 
over(partition by suburb order by bond_amount desc) as tent_length
from april_2025;
-- Self join-- 
select a.suburb, a.num_rooms, a.weekly_rent, p.suburb
from april_2025 a join april_2025 p on a.weekly_rent=p.weekly_rent and a.num_rooms=p.num_rooms;
-- create table Triggers--
create table row_alert(ID int auto_increment primary key, suburb varchar(100), bond_amount int, created_at timestamp);
desc row_alert;
-- Creating an alert when bond amount>3000--
Delimiter $$
create trigger high_amount
after insert on april_2025
for each row
begin if new.bond_amount>3000 then insert into row_alert (suburb, bond_amount)
values(new.suburb,new.bond_amount);
end if;
end$$

delimiter ;
-- To insert vales into the table--
INSERT INTO april_2025 (
  suburb, state, postcode, bond_amount, weekly_rent,
  Bond_act_date, bond_lodge_date, Num_rooms, dwelling_type,
  length_tenancy, housing_type, bond_status
)
VALUES (
  'SHOREWELL PARK', 'Tasmania', '7320', 5000.00, 390,
  '2025-01-04', '2025-02-04', 3, 'Separate House',
  '12', 'Private housing', 'Active'
);
-- To display the table-- 
select * from row_alert;
-- To modify the data type--
alter table row_alert modify created_at timestamp default current_timestamp;





