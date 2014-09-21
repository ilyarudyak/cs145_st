/*6.2.3 def*/

/* countries have both bb and bc*/
select country from Classes where type = "bb"
intersect
select country from Classes where type = "bc";

/* damaged ships fight in another*/
select * from Battles order by  battleDate desc;

select ship from Outcomes where result = "damaged"
intersect
select ship from Outcomes where result <> "damaged";

/* battles with at least 2 ships from the same country */

select battle, country, count(country) from
(select ship, country, battle from Classes join
(select ship, class, battle
from Outcomes join Ships on (ship = name)) R on Classes.class = R.class)
group by battle, country;

/*6.3.2 exists in all any */

/* classes at least one ship sunk*/
select class from Ships where name in 
(select ship from Outcomes where result = "sunk");

select class from Ships where name = any
(select ship from Outcomes where result = "sunk");

select class from Classes where exists
(select name from Ships where Ships.class = Classes.class and 
name in (select ship from Outcomes where result = "sunk"));

/* find the battles Kongo class participated */
select battle from Outcomes where ship in
(select name from Ships where class = "Kongo");


select battle from Outcomes where exists
(select name from Ships where class = "Kongo" and name = ship);

/*name of ships with max number of guns within same bore*/
select C1.class from Classes C1
where C1.bore >= all (select C2.bore from Classes C2 
    where C1.displacement = C2.displacement);

select name from Ships where class in
(select C1.class from Classes C1
where C1.bore >= all (select C2.bore from Classes C2 
    where C1.displacement = C2.displacement));

select class, bore, displacement
from Classes where concat(displacement,bore) in
(select concat(displacement,max(bore))  from Classes
group by displacement)
order by displacement;

