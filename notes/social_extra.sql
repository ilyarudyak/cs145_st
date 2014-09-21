/*Q1*/
select ID1, ID2 from Likes 
where ID2 not in (select ID1 from Likes);


select ID1 from Likes
order by ID1;

select H1.name, H1.grade, H2.name, H2.grade 
from Highschooler H1, Highschooler H2
where H1.ID || H2.ID in 
(select ID1 || ID2 from Likes 
where ID2 not in (select ID1 from Likes));

/*Q2*/
select L1.ID1, L1.ID2, L2.ID2  from Likes L1, Likes L2
where L1.ID2 = L2.ID1 and L1.ID1 <> L2.ID2;

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3
where H1.ID || H2.ID || H3.ID in
(select L1.ID1 || L1.ID2 || L2.ID2  from Likes L1, Likes L2
where L1.ID2 = L2.ID1 and L1.ID1 <> L2.ID2);

/*Q3*/
/*all of their friends are in different grades from themselves*/
select ID1, ID2, count(*) - sum(H1.grade <> H2.grade) as delta
from Friend, Highschooler H1, Highschooler H2
where ID1 = H1.ID and ID2 = H2.ID
group by ID1;

select ID1
from Friend, Highschooler H1, Highschooler H2
where ID1 = H1.ID and ID2 = H2.ID
group by ID1
having count(*) - sum(H1.grade <> H2.grade) = 0;


select name, grade from Highschooler
where ID = 1316;

select ID1, ID2, H1.grade as g1, H2.grade as g2
from Friend, Highschooler H1, Highschooler H2
where ID1 = H1.ID and ID2 = H2.ID
order by ID1, ID2;

select distinct R1.ID1 from 
(select ID1, ID2, H1.grade as g1, H2.grade as g2
from Friend, Highschooler H1, Highschooler H2
where ID1 = H1.ID and ID2 = H2.ID
order by ID1, ID2) R1
where R1.g1 not in
(select g2 from
(select ID1, ID2, H1.grade as g1, H2.grade as g2
from Friend, Highschooler H1, Highschooler H2
where ID1 = H1.ID and ID2 = H2.ID
order by ID1, ID2) R2
where R1.ID1 = R2.ID1);

