/* Delete the tables if they already exist */
drop table if exists Classes;
drop table if exists Ships;
drop table if exists Battles;
drop table if exists Outcomes;

/* Create the schema for our tables */
create table Classes(class text, type text, 
    country text, numGuns int, bore int, displacement int);
create table Ships(name text, class text, launched date);
create table Battles(name text, battleDate date); 
create table Outcomes(ship text, battle text, result text);


/* Populate the tables with our data */
insert into Classes values("Bismark", "bb", "Germany", 8, 15, 42000);
insert into Classes values("Iowa", "bb", "USA", 9, 16, 46000);
insert into Classes values("Kongo", "bc", "Japan", 8, 14, 32000);
insert into Classes values("North Carolina", "bb", "USA", 9, 16, 37000);
insert into Classes values("Renown", "bc", "Gt. Britain", 6, 15, 32000);
insert into Classes values("Revenge", "bb", "Gt. Britain", 8, 15, 29000);
insert into Classes values("Tennessee", "bb", "USA", 12, 14, 32000);
insert into Classes values("Yamato", "bb", "Japan", 9, 18, 65000);

insert into Battles values("Denmark Strait", "5/24/41");
insert into Battles values("Guadalcanal", "11/15/42");
insert into Battles values("North Cape", "12/26/43");
insert into Battles values("Surigao Strait", "10/25/44");

insert into Outcomes values("Arizona", "PearlHarbor", "sunk");
insert into Outcomes values("Bismark", "Denmark Strait", "sunk");
insert into Outcomes values("California", "Surigao Strait", "ok");
insert into Outcomes values("Duke of York", "North Cape", "ok");
insert into Outcomes values("Fuso", "Surigao Strait", "sunk");
insert into Outcomes values("Hood", "Denmark Strait", "sunk");
insert into Outcomes values("King George V", "Denmark Strait", "ok");
insert into Outcomes values("Kirishima", "Guadalcanal", "sunk");
insert into Outcomes values("Prince of Wales", "Denmark Strait", "damaged");
insert into Outcomes values("Rodney", "Denmark Strait", "ok");
insert into Outcomes values("Schanhorst", "North Cape", "sunk");
insert into Outcomes values("South Dakota", "Guadalcanal", "damaged");
insert into Outcomes values("Tennessee", "Surigao Strait", "ok");
insert into Outcomes values("Washington", "Guadalcanal", "ok");
insert into Outcomes values("West Virginia", "Surigao Strait", "ok");
insert into Outcomes values("Yamashiro", "Surigao Strait", "sunk");

insert into Ships values("California", "Tennesee", "1921");
insert into Ships values("Haruna", "Kongo", "1915");
insert into Ships values("Hiei", "Kongo", "1914");
insert into Ships values("Iowa", "Iowa", "1943");
insert into Ships values("Kirishima", "Kongo", "1915");
insert into Ships values("Kongo", "Kongo", "1913");
insert into Ships values("Missouri", "Iowa", "1944");
insert into Ships values("Musashi", "Yamato", "1942");
insert into Ships values("New Jersey", "Iowa", "1943");
insert into Ships values("North Carolina", "North Carolina", "1941");
insert into Ships values("Ramillies", "Revenge", "1917");
insert into Ships values("Renown", "Renown", "1916");
insert into Ships values("Repulse", "Renown", "1916");
insert into Ships values("Resolution", "Revenge", "1916");
insert into Ships values("Revenge", "Revenge", "1916");
insert into Ships values("Royal Oak", "Revenge", "1916");
insert into Ships values("Royal Sovereign", "Revenge", "1916");
insert into Ships values("Tennessee", "Tennessee", "1920");
insert into Ships values("Washington", "North Carolina", "1941");
insert into Ships values("Wisconsin", "Iowa", "1944");
insert into Ships values("Yamato", "Yamato", "1941");





