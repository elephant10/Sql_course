-- 1 List  the names of the cities in alphabetical order where Classic Models has offices. (7)

select distinct city from classicmodels.offices order by city;

--2 List the EmployeeNumber, LastName, FirstName, 
--Extension for all employees working out of the Paris office. (5)  

select employeenumber, lastname, firstname, "extension" from 
	classicmodels.employees 
	where officecode in 
		(select officecode from classicmodels.offices where city = 'Paris');

-- 3 List the ProductCode, ProductName, ProductVendor, 
--QuantityInStock and ProductLine for all products
--with a QuantityInStock between 200 and 1200. (11) 

select productcode, productname, productvendor, quantityinstock, productline
from classicmodels.products where quantityinstock between 200 and 1200;

-- 4 (Use a SUBQUERY) List the ProductCode, ProductName, ProductVendor,
-- BuyPrice and MSRP for the least expensive (lowest MSRP) product 
--sold by ClassicModels.  (“MSRP” is the Manufacturer’s Suggested Retail Price.)  (1)    

select productcode, productname, productvendor, buyprice, msrp 
from (select * from classicmodels.products order by msrp asc limit 1) as "msrpOrdered";

-- 5 What is the ProductName and Profit of the product that has 
--the highest profit (profit = MSRP minus BuyPrice). (1)   
select productname, (msrp - buyprice) as "profit" 
	from classicmodels.products 
	order by 2 desc limit 5;

-- 6
-- List the country and the number of customers 
--from that country for all countries having just two  customers.  
--List the countries sorted in ascending alphabetical order. 
--Title the column heading for the count of customers as “Customers”.(7)   

select country, count(customers) as "customers" 
	from classicmodels.customers 
	group by country 
	having (count(customers) = 2)
	order by country asc;
	
-- 7 List the ProductCode, ProductName, 
--and number of orders for the products with exactly 25 orders.  
--Title the column heading for the count of orders as “OrderCount”. (12)  

select pr.productcode, pr.productname, count(*) 
	from classicmodels.orders o join classicmodels.orderdetails ord 
			on o.ordernumber= ord.ordernumber
		join classicmodels.products pr on ord.productcode = pr.productcode 
	group by pr.productcode
		having count(*) = 25;
		
-- 8.List the EmployeeNumber, Firstname + Lastname  
--(concatenated into one column in the answer set, 
-- separated by a blank and referred to as ‘name’)
-- for all the employees reporting to Diane Murphy or Gerard Bondur. (8)  

select employeenumber, (firstname || ' ' || lastname) as "name"
	from classicmodels.employees
	where reportsto in 
		(select employeenumber from classicmodels.employees
			where (firstname = 'Diane' and lastname = 'Murphy')
		 			OR (firstname = 'Gerard' and lastname = 'Bondur'));
					
-- 9 List the EmployeeNumber, LastName, 
-- FirstName of the president of the company (the one employee with no boss.)  (1)  
select employeenumber, lastname, firstname from classicmodels.employees 
	where reportsto is null;

-- 10 List the ProductName for all products 
--in the “Classic Cars” product line from the 1950’s.  (6)

select productname from classicmodels.products
	where productline = 'Classic Cars' and productname like '195%';
	
-- 11 List the month name and the total number of orders for the month
-- in 2004 in which ClassicModels customers placed the most orders. (1)  

select to_char(orderdate, 'Month'), count (*)  
	from classicmodels.orders
	where (extract (year from orderdate) = 2004)
	group by to_char(orderdate, 'Month')
	order by count(*) desc
	limit 1; 
	
-- 12 List the firstname, lastname of employees who are 
-- Sales Reps who have no assigned customers.  (2) 

select firstname, lastname 
from classicmodels.employees emp left outer join classicmodels.customers cust on 
	emp.employeenumber = cust.salesrepemployeenumber
	where jobtitle = 'Sales Rep'
	group by firstname, lastname 
	having count(customername) = 0;
	
	
-- 13 List the customername of customers from Switzerland with no orders. (2)  

select customername 
from classicmodels.customers cust left outer join classicmodels.orders ord on 
	cust.customernumber = ord.customernumber
	where country = 'Switzerland'
	group by customername 
	having count (ordernumber) = 0;
	
-- 14 List the customername and total quantity of products 
-- ordered for customers who have ordered more than 1650
-- products across all their orders.  (8) 

select customername,  sum (quantityordered) 
	from classicmodels.orders o, classicmodels.orderdetails ord, classicmodels.customers cust
		where o.ordernumber = ord.ordernumber AND o.customernumber = cust.customernumber
	group by customername 
	having sum (quantityordered) > 1650;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--1. Create a NEW table named “TopCustomers” with three columns:
--CustomerNumber (integer), ContactDate (DATE) and  OrderTotal (a real number.) 
--None of these columns can be NULL.  

Create table TopCustomers (
	CustomerNumber  int,
	ContactDate  	Date, 
	OrderTotal      real
)

--2. Populate the new table “TopCustomers” with the CustomerNumber,
--today’s date, and the total value of all their orders (PriceEach * quantityOrdered)
--for those customers whose order total value is greater than $140,000. 
--(should insert 10 rows )

insert into TopCustomers (
	(select customernumber, current_date, 
			sum( priceeach * quantityordered) 
		from classicmodels.orderdetails ord join classicmodels.orders o on
			o.ordernumber = ord.ordernumber
		group by customernumber
		having sum( priceeach * quantityordered) > 140000));

--3.List the contents of the TopCustomers table in descending OrderTotal sequence. (10) 
select * from topcustomers 
	order by ordertotal desc;
	
-- 4 Add a new column to the TopCustomers table called OrderCount (integer).

alter table TopCustomers 
	add column "OrderCount" int;

-- 5 Update the Top Customers table, setting the OrderCount to a random number
-- between 1 and 10.  Hint:  use (RANDOM() *10)

create view randomView as 
	select (RANDOM() *10)::int as "rand";

update topcustomers
	set "OrderCount" = RANDOM() *10;
	
	
	(select rand from randomView);
-- 6 List the contents of the TopCustomers table in descending OrderCount sequence. (10 rows)

select * from topcustomers 
	order by 4 desc;
	
-- 7 Drop the TopCustomers table. (no answer set)  

drop table Topcustomers;