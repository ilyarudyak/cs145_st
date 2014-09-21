create view LateRating as
  select distinct R.mID, title, stars, ratingDate
  from Rating R, Movie M
  where R.mID = M.mID
  and ratingDate > '2011-01-20';

create view HighlyRated as
  select mID, title
  from Movie
  where mID in (select mID from Rating where stars > 3);

create view NoRating as
  select mID, title
  from Movie
  where mID not in (select mID from Rating);




create trigger HighlyRatedinsert
instead of insert on HighlyRated
for each row
when New.mID || New.title in (select mID || title from Movie)
begin
  insert into Rating values (201, New.mID, 5, null);
end;


create trigger NoRatinginsert
instead of insert on NoRating
for each row
when New.mID || New.title in (select mID || title from Movie)
begin
  delete from Rating where mID = New.mID;
end;



create trigger LateRatingupdate
instead of update of title, stars, mID on LateRating
for each row
begin
    update Movie 
    set title = New.title 
    where mID = New.mID;

    update Rating
    set stars = New.stars
    where mID = New.mID and ratingDate = New.ratingDate
    and ratingDate > "2011-01-20" ;
    
    update Movie
    set mID = New.mID
    where mID = Old.mID;
    update rating
    set mID = New.mID
    where mID = Old.mID;
end;
