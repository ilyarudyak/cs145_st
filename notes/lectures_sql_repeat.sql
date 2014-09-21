select distinct sID from Apply where major = 'CS' 
and sID in (select sID from Apply where major = "EE");


select *
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';


select *
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.sID = 123;


/* id and names applied to CS  */
select distinct Apply.sID, sName, major 
from Apply join Student on (Apply.sID = Student.sID)
where major = "CS";

select sID, sName
from Student
where sID in (select sID from Apply where major = "CS");

/* students applied to CS but not EE */
select sID from Student
where sID in (select sID from Apply where major = "CS")
and sID not in (select sID from Apply where major = "EE");

select sID from Apply where major = "CS"
except
select sID from Apply where major = "EE";


select sID, major from Apply
where sID = any (select sID from Apply where major = "CS")
and sID <> all (select sID from Apply where major = "EE");





/* colleges  with some other college in the same state*/
select cName
from College C1
where exists 
(select * from College C2 where C1.state = C2.state
and C1.cName <> C2.cName);

/* college with highest enrollment*/
select cName from College C1
where not exists 
(select * from College C2 
    where C2.enrollment > C1.enrollment);

select cName from College
where enrollment = (select max(enrollment) from College);

select cName from College
where enrollment >= all (select enrollment from College);

