select  group_concat(distinct cName) from Apply 
where sID = 123;

/* exercise 6.4.7 * /

/* d) for each class year when 1st ship launched*/

select class, min(launched) from Ships
group by class
order by class;


/* e) for each class ## of ships sunk in battle*/

select class, count(*) from Ships, Outcomes
where name = ship and result="sunk"
group by class;



select ship from Outcomes
where ship not in (select name from Ships);

select ship from Outcomes
where ship in (select name from Ships);

/* f) for each class with at least 3 ships 
 ## of sunk ships*/


select class from Ships
group by class
having count(*) > 2;


select class, count(*) from Ships
where class in
(select class from Ships
group by class
having count(*) > 2)
group by class;


select class, sum(a) from
(
select class, count(*) as a from
(select class, ship from Ships
where class in
(select class from Ships
group by class
having count(*) > 2)) join Outcomes using(ship)
where result like "%sunk%"
group by class

union

select class, 0 as a from 
(select class from Ships
group by class
having count(*) > 2)
)
group by class;












/* reparment of the table*/
select distinct class from Ships
where class not in (select class from Classes);

select ship from Ships where ship not in
(select ship from Outcomes);
