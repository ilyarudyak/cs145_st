/*Q1*/
create trigger LateRatingUpdate
instead of update of title on LateRating
for each row
begin
    update Movie
    set title = New.title
    where mID = Old.mID;    
end;

drop trigger LateRatingUpdate;

update LateRating set title = "E.T.1" where title = "E.T.";


/*Q2*/
create trigger LateRatingUpdate
instead of update of stars on LateRating
for each row
begin
    update Rating
    set stars = New.stars
    where mID = New.mID and ratingDate = New.ratingDate
    and ratingDate > "2011-01-20" ;    
end;


update LateRating set stars = stars - 2 where stars > 2; 
update LateRating set mID = 100, stars = stars + 2; 
update LateRating set ratingDate = null, stars = stars + 2;

/*Q3*/
create trigger R0
instead of update of mID on LateRating
for each row
begin
    update Movie
    set mID = New.mID
    where mID = Old.mID;
    update rating
    set mID = New.mID
    where mID = Old.mID;
end;

update LateRating set mID = 555 where stars = 2;
update LateRating set mID = mID+1000 where stars = 2;

select * from LateRating;

/*tests*/
create trigger R1
instead of update of title on LateRating
for each row
begin
    update Movie
    set title = New.title
    where mID = New.mID;
end;

update LateRating set title = "test" where mID = 101;
update LateRating set mID = 555, title = "test100" where mID = 101;

create trigger R2
instead of update of title on LateRating
for each row
begin
    update Movie
    set title = New.title
    where mID = Old.mID; /*Old instead of New*/
end;









/*Q4*/
create trigger HighlyRatedDelete
instead of delete on HighlyRated
for each row
begin
    delete from Rating
    where mID = Old.mID and stars > 3;
end;


delete from HighlyRated where mID > 106;

/*Q5*/
create trigger HighlyRatedDelete
instead of delete on HighlyRated
for each row
begin
    update Rating
    set stars = 3
    where mID = Old.mID and stars > 3;
end;
