/***************core set***************/
/*Q1*/
create trigger R1
after insert on Highschooler
for each row
when New.name = "Friendly"
begin
    insert into Likes  
    select New.ID, ID from Highschooler 
    where grade = New.grade and New.ID <> ID;
end;

insert into Highschooler values(1111, "Friendly", 9);

insert into Likes select 1, ID from Highschooler 
where grade = 9;

/*Q2*/
create trigger R2
after insert on Highschooler
for each row
when New.grade < 9 or New.grade > 12
begin
    update Highschooler set grade = null where New.ID = ID;
end;
|
create trigger R3
after insert on Highschooler
for each row
when New.grade is null
begin
    update Highschooler set grade = 9 where New.ID = ID;
end;

insert into Highschooler values(5555, "test", null);


/*Q3*/
create trigger R4
after update of grade on Highschooler
for each row
when New.grade = 13
begin
    delete from Highschooler where New.ID = ID;
end;


/*challenge set*/
/*Q1*/
create trigger R5
after delete on Friend
for each row
begin
    delete from Friend where ID1 = Old.ID2 and ID2 = Old.ID1;
end;
|
create trigger R6
after insert on Friend
for each row
begin
    insert into Friend values(New.ID2, New.ID1);
end;

/*Q2*/
create trigger R7
after update of grade on Highschooler
for each row
when New.grade > 12
begin
    delete from Highschooler where New.ID = ID;
end;
|
create trigger R8
after update of grade on Highschooler
for each row
begin
    update Highschooler set grade = grade + 1 where 
    ID in (select ID2 from Friend where ID1 = New.ID);
end;

/*Q3*/
/*If A liked B but is updated to A liking C instead, 
and B and C were friends, make B and C no longer friends.*/
create trigger R9
after update of ID2 on Likes
for each row
when Old.ID1 = New.ID1
begin
    delete from Friend where ID1 = Old.ID2 and ID2 = New.ID2;
    delete from Friend where ID1 = New.ID2 and ID2 = Old.ID2;
end;

update Likes set ID2 = 1501 where ID1 = 1911;
