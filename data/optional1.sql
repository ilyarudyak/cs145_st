/* a) Find all pizzerias frequented by at least 
one person under the age of 18.*/

select pizzeria from Person, Frequents 
where Person.name = Frequents.name and Person.age < 18;


/* b) Find the names of all females who eat 
either mushroom or pepperoni pizza (or both).*/

select distinct P.name from Person P, Eats E 
where P.name = E.name and (pizza = "pepperoni" or pizza = "mushroom") 
and gender = "female";

/* c) Find the names of all females who eat 
both mushroom and pepperoni pizza.*/

select P.name from Person P, Eats E 
where P.name = E.name and 
(pizza = "pepperoni" or pizza = "mushroom") and 
gender = "female"
group by P.name
having count(*) > 1;

/* d) Find all pizzerias that serve 
at least one pizza that 
Amy eats for less than $10.00.*/

select distinct pizzeria from eats E, Serves S
where E.pizza = S.pizza and name = "Amy" and price < 10;


/*e)  Find all pizzerias that are frequented 
by only females or only males */


(select distinct pizzeria from Frequents F, Person P
where F.name = P.name and gender = "male" and pizzeria not in
(select distinct pizzeria from Frequents F, Person P
where F.name = P.name and gender = "female"))
union
(select distinct pizzeria from Frequents F, Person P
where F.name = P.name and gender = "female" and pizzeria not in
(select distinct pizzeria from Frequents F, Person P
where F.name = P.name and gender = "male"));



select  pizzeria, gender from Frequents F, Person P
where F.name = P.name order by pizzeria;



/* f) For each person, find all pizzas 
the person eats that are not served by any pizzeria 
the person frequents. 
Return all such person (name) / pizza pairs. */


select P.name, E.pizza
from Person P, Eats E
where P.name = E.name 
and E.pizza not in
(select S1.pizza from Person P1, Frequents F1, Serves S1
where P1.name = F1.name and F1.pizzeria = S1.pizzeria
and P1.name = P.name);


/* g) Find the names of all people 
who frequent only pizzerias serving 
at least one pizza they eat. */

select name from Person where name not in
(select name from Frequents where concat(name, pizzeria) not in
(select  concat(F.name, F.pizzeria)
from Frequents F, Eats E
where F.name = E.name
and E.pizza in
(select S1.pizza from Serves S1 
where S1.pizzeria = F.pizzeria)));

/* h) Find the names of all people 
who frequent every pizzeria 
serving at least one pizza they eat. */

select distinct name from Frequents where name not in
(select distinct name from
(select N.name as name, P.pizzeria as pizzeria from
(select distinct name from Frequents) N,
(select distinct pizzeria from Serves) P
where P.pizzeria in
(select distinct pizzeria from Serves
where pizza in 
(select pizza from Eats where name = N.name))) R
where concat(name,pizzeria) not in
(select concat(name,pizzeria) from Frequents));



select distinct pizzeria from Serves
where pizza in 
(select pizza from Eats where name = "Amy");

/* i) Find the pizzeria serving the cheapest pepperoni pizza. 
In the case of ties, return all of the
cheapest-pepperoni pizzerias.*/

select pizzeria from Serves 
where price =
(select min(price) from Serves
where pizza = "pepperoni");



