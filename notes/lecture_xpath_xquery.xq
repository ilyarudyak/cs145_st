(: title of books with price < 90 and Ullman is an author:)
for $book in doc("BookstoreQ.xml")/Bookstore/Book
    where $book/@Price < 90 and 
          $book/*/*/Last_Name = "Ullman"
return $book/Title  


(: title and author first names where title contains this name :)
for $book in doc("BookstoreQ.xml")/Bookstore/Book
    where some $fn in $book/*/*/First_Name
        satisfies contains($book/Title, $book/*/*/First_Name)
return <Book>
        {$book/Title} 
        {$book/*/*/First_Name}
       </Book>

(: find the average book price :)
<Average>
    {let $plist := doc("BookstoreQ.xml")/Bookstore/Book/@Price
     return avg($plist)}
</Average>    

(: find books with price below average :)



(: title and prices sorted by price:)
for $book in doc("BookstoreQ.xml")/Bookstore/Book
order by xs:int ($book/@Price)
return <Book>
        {$book/Title}
        <Price>{$book/data(@Price)}</Price>
      </Book>  

