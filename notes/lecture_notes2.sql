/* illustrate inner join: on, using (preferred), natural*/
select distinct sName, major from Student, Apply
where Student.sID = Apply.sID;


select distinct sName, major from Student join Apply
on Student.sID = Apply.sID;

select distinct sName, major from Student join Apply
using(sID);

select distinct sName, major from Student natural join Apply;



/* illustrate outer join*/
select sID, sName, cName, major
from Student join Apply using (sID);


select sID, sName, cName, major
from Student left outer join Apply using (sID);



select sID, sName, null, null from Student
where sID not in 
(select sID from Apply)
union 
select sID, sName, cName, major
from Student join Apply using (sID);
