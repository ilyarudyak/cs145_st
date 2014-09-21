/* 1) IDs and names of students applied to CS */
select distinct sID, sName from Student where sID in (select sID from Apply where major = 'CS');

/* 2) IDs and names of students applied to CS but not EE */
select distinct sID, sName from Student where sID in (select sID from Apply where major = 'CS') and sID not in (select sID from Apply where major = 'EE');

/* 3) All colleges that there is another college in the same state */
select cName, state from College C1 where exists (select cName from College C2 where C1.state = C2.state and C1.cName <> C2.cName);

/* 4) College with highest enrollment */ 
select cName from College C1 where not exists (select * from College C2 where C1.enrollment < C2.enrollment);

/* 6) Students not from smallest high school */
select sID, sName, sizeHS from Student S1 where exists (select * from Student S2 where S1.sizeHS > S2.sizeHS); 

select * from Student where sizeHS > any (select sizeHS from Student); 

/* subqueries in from-select */
/* colleges paired with highest GPA of applicants */
select distinct College.cName, state, GPA from College, Student, Apply where College.cName = Apply.cName and Student.sID = Apply.sID and GPA = (select max(GPA) from Student);

select cName, state, (select distinct GPA from Student, Apply where College.cName = Apply.cName and Student.sID = Apply.sID and GPA = (select max(GPA) from Student)) as GPA from College;


/* Movie Q7 find highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title */
select distinct S1.title, S1.stars from 
(select title, stars from Movie, Rating where Movie.mID = Rating.mID) S1
where S1.stars = 
(select max(S2.stars) from
(select title, stars from Movie, Rating where Movie.mID = Rating.mID) S2
where S1.title = S2.title)
order by title;


/* Movie Q8 list movies by average rating*/
select distinct S1.title, 
(select avg(S2.stars) from
(select title, stars from Movie, Rating where Movie.mID = Rating.mID) S2
where S1.title = S2.title) as avgStars
from 
(select title, stars from Movie, Rating where Movie.mID = Rating.mID) S1 
order by avgStars desc, title;

/* Movie Q9 reviewers who have contributed three or more ratings */
select name from Reviewer R1,
(select distinct S1.rID,
(select count(S2.rID) from Rating S2 where S1.rID = S2.rID) as numOfRatings
from Rating S1
where numOfRatings >= 3) R2
where R1.rID = R2.rID;

/**
* aggregation
*/

/* average GPA of those who applied to CS */

select avg(gpa) from Student, Apply where Student.sID = Apply.sID 
and major = 'CS';

select * from Student, Apply where Student.sID = Apply.sID and
major = 'CS';

select avg(gpa) from Student where sID in 
(select sID from Apply where major = 'CS');


/* count and count distinct */
select sID from Apply where cName = 'Cornell';
select count(*) from Apply where cName = 'Cornell';

select count(distinct sID) from Apply where cName = 'Cornell';

/* group by */
select cName, count(*)
from Apply
group by cName;


select cName, major, min(GPA), max(GPA)
from Student, Apply
where Student.sID = Apply.sID
group by cName, major;

/* number of colleges applied to by each student */
select * 
from Student, Apply
where Student.sID = Apply.sID;

select Student.sID, sName, count(distinct cName) 
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/* having */
select cName
from Apply
group by cName
having count(*) < 5;

select cName
from (select cName, count(*) as cnt from Apply group by cName) S
where S.cnt < 5;


/* social standard set */
/* Q1 */
select name
from Highschooler,
(select Friend.ID2 as ID
from Highschooler, Friend
where Highschooler.ID = Friend.ID1 and name = 'Gabriel') R
where Highschooler.ID = R.ID;

/* Q2 */
select name1, grade1, name2, grade2 
from
(select R.ID1, R.name1 as name1, R.grade1 as grade1, R.ID2, Highschooler.name as name2, Highschooler.grade as grade2, R.grade1 - Highschooler.grade as diff
from
(select Highschooler.ID as ID1, name as name1, Highschooler.grade as grade1, Likes.ID2 as ID2 
from Highschooler, Likes
where Highschooler.ID = Likes.ID1) R, Highschooler
where Highschooler.ID = R.ID2)
where diff >= 2;

/* Q3 */

select name1, grade1, name2, grade2 from
(select H1.name as name1, H1.grade as grade1, H2.name as name2, H2.grade as grade2, L.ID1 + L.ID2 as sm
from Highschooler H1, Highschooler H2, Likes L
where H1.ID = L.ID1 and H2.ID = L.ID2) R1
where name1 <= name2 and R1.sm in

(select R21.sm from
(select R20.sm, count(*) as cnt from
(select H1.name as name1, H1.grade as grade1, H2.name as name2, H2.grade as grade2, L.ID1 + L.ID2 as sm
from Highschooler H1, Highschooler H2, Likes L
where H1.ID = L.ID1 and H2.ID = L.ID2) R20
group by R20.sm) R21
where R21.cnt = 2);

/* Q4 */
select name1, grade1 from
(select ID1, name1, grade1 from
(select H1.ID as ID1, H1.name as name1, H1.grade as grade1, H2.ID as ID2, H2.name as name2, H2.grade as grade2, H1.grade - H2.grade as diff
from Highschooler H1, Highschooler H2, Friend F
where H1.ID = F.ID1 and H2.ID = F.ID2 and (H1.grade - H2.grade) = 0)
except
select ID1, name1, grade1 from
(select H1.ID as ID1, H1.name as name1, H1.grade as grade1, H2.ID as ID2, H2.name as name2, H2.grade as grade2, H1.grade - H2.grade as diff
from Highschooler H1, Highschooler H2, Friend F
where H1.ID = F.ID1 and H2.ID = F.ID2 and (H1.grade - H2.grade) <> 0))
order by grade1, name1;


/* simplified version: 1) A = take id where friend from the same grade and 2) B = NOT from the same 3) take A-B*/
select name, grade from Highschooler, 
(select H1.ID as ID
from Highschooler H1, Highschooler H2, Friend F
where H1.ID = F.ID1 and H2.ID = F.ID2 and H1.grade = H2.grade
except
select H1.ID as ID
from Highschooler H1, Highschooler H2, Friend F
where H1.ID = F.ID1 and H2.ID = F.ID2 and H1.grade <> H2.grade) R
where Highschooler.ID = R.ID
order by grade, name;

/* Q5 */
select name, grade from Highschooler,
(select ID2 as ID, count(*) as cnt
from Likes
group by ID2) S
where Highschooler.ID = S.ID and S.cnt > 1;

/* Social - challenging set*/

/* Q1 1) find all IDs in Likes using set operations 2) use not in operator to select from Highschooler */
select name, grade from Highschooler
where ID not in
(select ID1 as ID from Likes
UNION
select ID2 as ID from Likes)
order by grade, name;

/* Q2 */

/* WRONG assumption - those who likes each other are the only friends*/
/* ID1 likes ID2 and they are not friends*/
select ID1, ID2 from Likes
except
select L1.ID1 as ID1, L1.ID2 as ID2
from Likes L1, Likes L2
where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1;


/* find ABC IDs*/
select S.ID1 as A, S.ID2 as B,  F1.ID2 as C
from Friend F1, Friend F2,
(select ID1, ID2 from Likes
except
select L1.ID1 as ID1, L1.ID2 as ID2
from Likes L1, Likes L2
where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1) S
where A = F1.ID1 and C = F2.ID1 and F2.ID2 = B;



/* final result */
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3,
(select S.ID1 as A, S.ID2 as B,  F1.ID2 as C
from Friend F1, Friend F2,
(select ID1, ID2 from Likes
except
select L1.ID1 as ID1, L1.ID2 as ID2
from Likes L1, Likes L2
where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1) S
where A = F1.ID1 and C = F2.ID1 and F2.ID2 = B) R
where H1.ID = R.A and H2.ID = R.B and H3.ID = R.C;

/* find those who are not friends by direct checking Friend table*/
select ID1, ID2 from Likes
except
select L.ID1, L.ID2 
from Likes L, Friend F 
where L.ID1 = F.ID1 and L.ID2 = F.ID2;


select S.ID1 as A, S.ID2 as B,  F1.ID2 as C
from Friend F1, Friend F2,
(select ID1, ID2 from Likes
except
select L.ID1, L.ID2 
from Likes L, Friend F 
where L.ID1 = F.ID1 and L.ID2 = F.ID2) S
where A = F1.ID1 and C = F2.ID1 and F2.ID2 = B;

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3,
(select S.ID1 as A, S.ID2 as B,  F1.ID2 as C
from Friend F1, Friend F2,
(select ID1, ID2 from Likes
except
select L.ID1, L.ID2 
from Likes L, Friend F 
where L.ID1 = F.ID1 and L.ID2 = F.ID2) S
where A = F1.ID1 and C = F2.ID1 and F2.ID2 = B) R
where H1.ID = R.A and H2.ID = R.B and H3.ID = R.C;

/* Q3 */

select s - dfn from
(select count(*) as s
from Highschooler),
(select count(*) dfn from
(select distinct name
from Highschooler));

/* Q4 average # of friends per student*/

select avg(n) from
(select ID1, count(*) as n
from Friend
group by ID1);

/* Q5 friends of Cassandra*/

select count(*) from
(select ID2
from Friend
where ID1 = 1709
union
select ID2 from Friend 
where ID2 <> 1709 and ID1 in
(select ID2
from Friend
where ID1 = 1709));

/* Q6 student with the greatest # of friends*/

select name, grade from Highschooler H,
(select ID1 as ID from
(select ID1, count(*) as nof
from Friend
group by ID1)
where nof =
(select max(nof) from
(select ID1, count(*) as nof
from Friend
group by ID1))) R
where H.ID = R.ID;









































