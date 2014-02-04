/* insert statement*/

insert into College values('Carnegie Mellon', 'PA', 11500);

/* all students who didn't apply anywhere apply to CM*/
insert into Apply 
select sID, 'Carnegie Mellon', 'CS', null
from Student
where sID not in (select sID from Apply);


select sID from Student
except
select sID from Apply;

/* admit to CM EE those who applied to EE elsewhere and was rejected */
insert into Apply
select sID, 'Carnegie Mellon', 'EE', 'Y'
from Apply 
where decision = 'N' and major = 'EE';

/* delete statement */

delete from Student
where sID in
(select sID
from Apply
group by sID
having count(distinct major) > 2);

/* HW Social */
/* Q1 remove 12 grade */

delete from Highschooler
where grade = 12;

/* Q2 remove from Likes A and B are friends, and A likes B but not vice-versa */


delete from Likes
where ID1 + ID2 in
(select S.ID1 + S.ID2 from 
(select *
from Likes
except
select L1.ID1, L1.ID2
from Likes L1, Likes L2
where L1.ID2 = L2.ID1 and L1.ID1 = L2.ID2) S,
Friend F
where S.ID1 = F.ID1 and S.ID2 = F.ID2);





/* A likes B but not vice-versa */
select *
from Likes
except
select L1.ID1, L1.ID2
from Likes L1, Likes L2
where L1.ID2 = L2.ID1 and L1.ID1 = L2.ID2;


/* A is friends with B, and B is friends with C, add a new friendship for the pair A and C */
insert into Friend
select * from
(select F1.ID1, F2.ID2
from Friend F1, Friend F2
where F1.ID2 = F2.ID1 and F1.ID1 <> F2.ID2
except
select *
from Friend);



/* aggregation from the book */

select distinct director from Movie where director is not null;

select director from Movie where director is not null
union
select director from Movie where mID <> 105; 

select avg(stars) from Rating;
select count(*) from Movie where director is not null;
select count(distinct director) from Movie where director is not null;
select count(distinct director) from Movie;


select rID, count(*) from Rating group by rID;
select rID, count(stars) from Rating group by rID;
select mID, avg(stars) from Rating group by mID;
select mID, count(stars) from Rating group by mID;
select mID, avg(stars) from Rating group by mID having avg(stars) > 3;
select mID, avg(stars) as a from Rating group by mID having a > 3;



select Movie.mID, title, avg(stars) from Movie, Rating where Movie.mID = Rating.mID group by rID;



/* subqueries from lectures WHERE */
/* id and name those who applied to CS somewhere */

select sID, sName 
from Student
where sID in (select sID from Apply where major = 'CS');

/* all colleges with some other college in the same state */
select cName, state
from College C1
where exists (select cName from College C2 where C1.state = C2.state and C1.cName <> C2.cName);

/* challenge HW Movie */

/* Q1 title and spread of rating */
select title, spread
from Movie, 
(select mID, max(stars) - min(stars) as spread
from Rating
group by mID) S
where Movie.mID = S.mID
order by spread desc, title;

/* Q2 average rating movies before and after 1980 */
select distinct

(select avg(mavg) from
(select mID, year, avg(stars) as mavg from 
(select Movie.mID, year, stars
from Movie, Rating
where Movie.mID = Rating.mID
order by year) 
group by mID)
where year < 1980) -

(select avg(mavg) from
(select mID, year, avg(stars) as mavg from 
(select Movie.mID, year, stars
from Movie, Rating
where Movie.mID = Rating.mID
order by year) 
group by mID)
where year >= 1980) as diff

from Movie;



/* average by movie */
select mID, year, avg(stars) as mavg from 
(select Movie.mID, year, stars
from Movie, Rating
where Movie.mID = Rating.mID
order by year) 
group by mID;



/* working table */
select Movie.mID, year, stars
from Movie, Rating
where Movie.mID = Rating.mID
order by year;


/* Q3 movies and director if directed >1 movie */

select title, director
from Movie
where director in
(select director
from Movie
where director is not null
group by director
having count(*) > 1)
order by director, title;


/* Q4 movie with the highest average rating */

select title, mx from Movie,
(select mID, max(mavg) as mx from
(select mID, avg(stars) as mavg
from Rating
group by mID)) S
where Movie.mID = S.mID;

/* Q5 the same with min rating*/



select title, mavg from Movie,

(select mID, mavg from
(select mID, avg(stars) as mavg
from Rating
group by mID) 
where mavg =
(select min(mavg) from 
(select mID, avg(stars) as mavg
from Rating
group by mID))) S
where Movie.mID = S.mID; 



/* Q6 director and title with highest rating */


select director, title, max(maxs) from

(select director, title, maxs
from Movie,
(select mID, max(stars) as maxs
from Rating
group by mID) S 
where director is not null and Movie.mID = S.mID)

group by director;


/* HW challenge modification */


/* all movies that have an average rating of 4 stars or higher */
select mID from Rating group by mID having avg(stars) >= 4;


/* movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars */

select Movie.mID, Rating.stars from Movie, Rating where Movie.mID = Rating.mID and (year < 1970 or year > 2000) and stars < 4;

