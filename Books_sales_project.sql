create database Book_Projects;

use Book_projects;

select * from Books
select * from Customers
select * from Orders

---1) Retrieve all books in the "Fiction" genre

select * from books
where Genre ='Fiction';

---2) Find books published after the year 1950
select * from books
where Published_Year <1950;

---- 3)List all customers from the Canada
select * from Customers
where Country='Canada'

---4) Show orders placed in November 2023

select * from Orders
where Order_Date between '2023-11-01' and '2023-11-30'	;

----5) Retrieve the total stock of books available

select * from Books

select sum(stock) as total_stock from books 

----6) Find the details of the most expensive book

select TOP 10* from Books order by Price desc;

---7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM Orders
WHERE Quantity >1;

---8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE Total_Amount>20;


----9) List all genres available in the Books table
select * from Books
select DISTINCT Genre FROM Books

SELECT Genre, COUNT(Stock) AS Avail_Stock
FROM Books
GROUP BY Genre
ORDER BY Genre;

---10) Find the book with the lowest stock

select top 10* from Books
order by Stock;


-----11) Calculate the total revenue generated from all orders

select sum(Total_Amount) as Revenue from Orders


-------Advance Queries

select * from Books
select * from Orders
select * from Customers

---1) Retrieve the total number of books sold for each genre

select sum(o.Quantity) as Total_sold,  b.genre from Orders o
join books b on 
o.Book_ID=b.Book_ID
group by b.Genre;

---2) Find the average price of books in the "Fantasy" genre

select AVG(price) as AVG_price from Books
where genre =  'Fantasy'


-----3) List customers who have placed at least 2 orders
select *from Orders
select * from Customers


select O.Customer_ID,C.NAME, count(Order_ID) as Order_count from Orders O
JOIN CUSTOMERS C ON O.Customer_ID=C.Customer_ID
group by O.Customer_ID,C.Name having COUNT (Order_ID)>=2;


------4) Find the most frequently ordered book
select *from Orders
select * from Books

select top 1 o.Book_ID,b.title, count(o.order_id) as order_total from Orders o 
join books b on b.book_id=o.book_id
group by o.Book_ID,b.title order by order_total

---5) Show the top 3 most expensive books of 'Fantasy' Genre

select top 3 *from books
where Genre='Fantasy'
order by price desc

----6) Retrieve the total quantity of books sold by each author

select * from Books
select * from Orders

select b.author,sum(o.quantity) as Total_sold from Orders o
join Books b
on
b.Book_ID=o.Book_ID
group by b.Author,o.Quantity
order by Total_sold


----7) List the cities where customers who spent over $30 are located

select * from Customers
select * from Orders

select distinct c.city, total_amount from Orders O
join Customers C
on 
o.Customer_ID=c.Customer_ID where o.Total_Amount >30

----8) Find the customer who spent the most on orders
SELECT TOP 10 c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC;

----9) Calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID, b.Title, 
       b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;



select b.Book_ID,b.Title,b.Stock-coalesce(sum(o.quantity),0) as left_stock
from Books b
left join Orders o on b.Book_ID = o.Book_ID group by b.Book_ID,b.Title,b.Stock
order by left_stock desc