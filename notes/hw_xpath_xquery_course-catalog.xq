(: Return all Title elements (of both departments and courses). :)
doc("courses.xml")//Title


(: Return last names of all department chairs. :)
doc("courses.xml")//Chair/*/Last_Name


(: Return titles of courses with enrollment greater than 500. :)
doc("courses.xml")//Course[@Enrollment > 500]/Title


(: Return titles of departments 
that have some course that takes "CS106B" 
as a prerequisite. :)
(: INCORRECT doc("courses.xml")//Department[//Prereq = "CS106B"]/Title :)
doc("courses.xml")//*[Prereq = "CS106B"]/ancestor::Department/Title
doc("courses.xml")//Department[Course/Prerequisites/Prereq = "CS106B"]/Title


(: Return last names of all professors or lecturers 
who use a middle initial. Don't worry about eliminating duplicates. :)
doc("courses.xml")//Middle_Initial/parent::*/Last_Name


(: Return the count of courses 
that have a cross-listed course 
(i.e., that have "Cross-listed" in their description).  :)
doc("courses.xml")/count(//Course[contains(Description, "Cross-listed")])


(: Return the average enrollment of all courses in the CS department.  :)
doc("courses.xml")/avg(//Department[@Code="CS"]/Course/data(@Enrollment))


(: Return last names of instructors 
teaching at least one course that has "system" in its description 
and enrollment greater than 100. :)
doc("courses.xml")//Course[@Enrollment > 100 and contains(Description, "system")]/Instructors/*/Last_Name

(: ********challeng level********:)

(: Return the title of the course with the largest enrollment. :)
doc("courses.xml")//Course[data(@Enrollment) = max(//Course/data(@Enrollment))]/Title


(: Return course numbers of courses 
that have the same title as some other course.  :)
doc("courses.xml")//Course[Title = ./preceding::Course/Title or 
					  Title = ./following::Course/Title]
					  /data(@Number)

(: Return the number (count) of courses that have no lecturers as instructors. :)
doc("courses.xml")/count(//Course[count(Instructors/Lecturer) = 0])


(: Q4 Return titles of courses taught by the chair of a department. :)
doc("courses.xml")/
doc("courses.xml")//Course[Instructors/*/Last_Name = ancestor::*/Chair/*/Last_Name]/Title


(: Return titles of courses taught 
by a professor with the last name "Ng" 
but not by a professor with the last name "Thrun". :)
doc("courses.xml")//Course[Instructors/*/Last_Name = "Ng" and 
						count(Instructors/*[Last_Name = "Thrun"]) = 0]/Title

(: Return course numbers of courses that have 
a course taught by Eric Roberts as a prerequisite.  :)
doc("courses.xml")//Course[*/Prereq = //Course[Instructors/*/Last_Name = "Roberts"]/data(@Number)]/data(@Number)


(: Create a summary of CS classes: 
List all CS department courses in order of enrollment.
For each course include only its Enrollment (as an attribute) 
and its Title (as a subelement).  :)
<Summary> 
{for $c in doc("courses.xml")/Course_Catalog/Department[@Code = "CS"]/Course
order by xs:int($c/data(@Enrollment))
return 
        <Course >
		{$c/@Enrollment}
        <Title> {$c/data(Title)}</Title>
        </Course>
}</Summary> 


(: Return a "Professors" element that contains as subelements 
a listing of all professors in all departments, 
sorted by last name with each professor appearing once.  :)
<Professors>{
for $ln in distinct-values (doc("courses.xml")//Professor/Last_Name)
let $fn := distinct-values(doc("courses.xml")//Professor[Last_Name = $ln]/First_Name)
let $p := doc("courses.xml")//Professor[Last_Name = $ln and empty(Middle_Initial)]
let $p1 := doc("courses.xml")//Professor[Last_Name = $ln and exists(Middle_Initial)]
order by $ln
return <Professor>
	   <First_Name>{$fn}</First_Name>	
        {$p1/Middle_Initial}
        <Last_Name>{$ln}</Last_Name>
       </Professor>
}</Professors>


