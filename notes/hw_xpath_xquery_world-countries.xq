(: Return the area of Mongolia :)
doc("countries.xml")//country[@name="Mongolia"]/data(@area)

(: Return the names of all cities that have 
the same name as the country in which they are located. :)
doc("countries.xml")//city[name = parent::node()/@name]/name

(: Return the average population of Russian-speaking countries. :)
doc("countries.xml")/avg(//country[language = "Russian"]/data(@population))

(: Return the names of all countries 
where over 50% of the population speaks German. :)
doc("countries.xml")//country[language = "German"]/language[. = "German" and @percentage > 50]/parent::node()/data(@name)

(: Return the name of the country with the highest population. :)
doc("countries.xml")//country[@population = max(//country/xs:int(data(@population)))]/data(@name)


(:**********challenge set************:)
(: Return the names of all countries that 
have at least three cities with population greater than 3 million.  :)
doc("countries.xml")//country[count(city[population > 3000000])>2]/data(@name)

(: Q2 Create a list of French-speaking and German-speaking countries. :)
<result>
<French>{
for $c in doc("countries.xml")//country[language = "French"]
let $cname := $c/data(@name)
return <country>{$cname}</country>
}</French>
<German>{
for $c in doc("countries.xml")//country[language = "German"]
let $cname := $c/data(@name)
return <country>{$cname}</country>
}</German>
</result>


(: Q3 Return the names of all countries containing a city 
such that some other country has a city of the same name. :)
doc("countries.xml")//country[city/name = following::country/city/name or
						city/name = preceding::country/city/name]/data(@name)


(: Q4 Return the average number of languages 
spoken in countries where Russian is spoken.  :)
doc("countries.xml")/avg(//country[language = "Russian"]/count(language))


(: Q5 name of the country textually contains the language name :)
for $l in doc("countries.xml")//language[contains(parent::*/@name, .)]
let $c := $l/parent::*/data(@name)
let $ltext := $l/text()
return <country>{attribute {"language"}{$ltext}}{$c}</country>


(: Q6 Return all countries that have at least one city 
with population greater than 7 million. :)
for $country in doc("countries.xml")//country[city/population > 7000000]
let $co_name := $country/data(@name)
return <country>{attribute{"name"}{$co_name}}
{
for $city in $country/city[population > 7000000]
let $ci_name := $city/name/text()
return <big>{$ci_name}</big>
}</country>



(: Q7 Return all countries where at least one language is listed,
 but the total percentage for all listed languages is less than 90%. :)
for $country in doc("countries.xml")//country[boolean(language) and 
								sum(language/data(@percentage)) < 90]
let $cname := $country/data(@name)
let $l := $country/language
return <country>{attribute{"name"}{$cname}}{$l}</country>



(: Q8 Return all countries where at least one language is listed, and every listed language is spoken by less than 20% of the population.:)
for $country in doc("countries.xml")//country[boolean(language) and 
								max(language/data(@percentage)) < 20]
let $cname := $country/data(@name)
let $l := $country/language
return <country>{attribute{"name"}{$cname}}{$l}</country>


(:Q9 Find all situations where one country's most popular language 
is another country's least popular, and both countries list more than one language. :)

(: version1 :)
for $c1 in doc("countries.xml")//country[count(language) > 1]
let $most := $c1/language[xs:float(data(@percentage)) = min($c1/language/xs:float(data(@percentage)))]
return <LangPair>{attribute{"language"}{$most/text()}}	
{
	for $c2 in doc("countries.xml")//country[count(language) > 1]
	let $least := $c2/language[xs:float(data(@percentage)) = min($c2/language/xs:float(data(@percentage)))]
	return if ($most/text() = $least/text() and $c1 != $c2)
		  then $c2/data(@name)
		  else ()

}</LangPair>

(: version2 :)
for $c1 in doc("countries.xml")//country[count(language) > 1]
let $most := $c1/language[xs:float(data(@percentage)) = max($c1/language/xs:float(data(@percentage)))]
return <LangPair>{attribute{"language"}{$most/text()}}<MostPopular>{$c1/data(@name)}</MostPopular>
<LeastPopular>{
	for $c2 in doc("countries.xml")//country[count(language) > 1]
	let $least := $c2/language[xs:float(data(@percentage)) = min($c2/language/xs:float(data(@percentage)))]
	return if ($most/text() = $least/text() and $c1 != $c2)
		  then $c2/data(@name)
		  else ()
}</LeastPopular>
</LangPair>


(: version3 :)
for $c1 in doc("countries.xml")//country[count(language) > 1]
let $most := $c1/language[xs:float(data(@percentage)) = max($c1/language/xs:float(data(@percentage)))]
let $pair := doc("countries.xml")//country[count(language) > 1 and data(@name) != $c1/data(@name)]/language[text() = $most/text()]
return if (boolean($pair)) then

<LangPair>{attribute{"language"}{$most/text()}}<MostPopular>{$c1/data(@name)}</MostPopular>
<LeastPopular>{
	for $c2 in doc("countries.xml")//country[count(language) > 1]
	let $least := $c2/language[xs:float(data(@percentage)) = min($c2/language/xs:float(data(@percentage)))]
	return if ($most/text() = $least/text() and $c1 != $c2)
		  then $c2/data(@name)
		  else ()
}</LeastPopular>
</LangPair>
	else ()

(: version 4 ****correct******:)
for $c1 in doc("countries.xml")//country[count(language) > 1]
let $most := $c1/language[xs:float(data(@percentage)) = max($c1/language/xs:float(data(@percentage)))]
for $pair in doc("countries.xml")//country[count(language) > 1 and data(@name) != $c1/data(@name)]/
			language[text() = $most/text() and 
			xs:float(data(@percentage)) = min(parent::country/language/xs:float(data(@percentage)))]
return 

<LangPair>{attribute{"language"}{$pair/text()}}<MostPopular>{$c1/data(@name)}</MostPopular>
<LeastPopular>{
	$pair/parent::country/data(@name)
}</LeastPopular>
</LangPair>


(: Q10 :)
