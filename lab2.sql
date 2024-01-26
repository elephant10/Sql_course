select * from products;

select order_id,  customer_id, shipped_date 
	from orders
	where ship_country = 'Canada' 
		and shipped_date between '1996-12-01' and '1999-12-31';
		---and ( EXTRACT(YEAR FROM shipped_date) = 1997 OR
			---( EXTRACT(YEAR FROM shipped_date) = 1996 AND 
			 	--- EXTRACT(MONTH FROM shipped_date) = 12));
				 
select product_id, product_name, quantity_per_unit 
	    from products
	    where quantity_per_unit like '%bottles%';
		
select count(distinct (country || city))  from suppliers;

select distinct (country || city||supplier_id),
company_name, supplier_id from suppliers order by 3 desc limit 5;

SELECT MAX(unit_price)
		FROM products;
		
select (title || ' ' || last_name || ' ' || 'first name') as "who", 
	hire_date, birth_date, age(hire_date, birth_date) AS "age" 
		from employees;

select to_date('01-01-01', 'yy-mm-dd'),
	age (current_date::timestamp, hire_date::timestamp)::text, 
	extract (year from birth_date) 
		from employees order by birth_date desc;
		
select to_date('01-01-01', 'yy-mm-dd');

select first_name || ' ' || last_name as "employee", hire_date 
	from employees
	where extract( year from hire_date) = 1993; 
	
select Last_name, First_name 
	     from employees
	     where Last_name between 'A' and 'M';
		 
SELECT Employee_ID, Last_name, First_name, 
	 (age(Hire_Date, Birth_Date)::text) AS "HIRE_AGE", 
	 	TO_CHAR(birth_date, 'month') 
	FROM employees;
	
-----------------------------
select sum(units_in_stock) from products ;

select to_char(avg(unit_price), '99.0000') from products;

SELECT order_ID, SUM(Unit_Price), SUM(Quantity) 
     FROM order_details
     WHERE Order_ID in (10248, 10249, 10250, 10251)
	 group by order_id ;
	 
SELECT order_ID, avg (Unit_Price), avg (Quantity) 
     FROM order_details
	 group by order_id ;
	 
select country, count(country) from customers group by country; 

select supplier_id, round(avg(unit_price)::numeric,2),
	to_char(avg(unit_price),'999.99') 
		from products group by supplier_id;
		
select supplier_id, round(avg(unit_price)::numeric,2),
	to_char(avg(unit_price),'999.99') 
		from products 
		group by supplier_id 
		order by 2;
		
select country, count (customer_id) as "aaaaa"
	from customers
	group by country
		having count (customer_id) > 5
	order by 2 desc
	limit  4;
	

SELECT product_id, product_name, unit_price
		FROM products
		where unit_price in (
				SELECT unit_price
				FROM products
				order by unit_price desc
				limit  3)
		order by unit_price desc;
				
				
select product_name, 
		(select sum(unit_price * quantity) as "Total"
		from order_details 
		where order_details.product_id = products.product_id)
	from products;

select product_name, product_id, unit_price 
	from products 
	where unit_price = (select min(unit_price) from products);
	
select count (order_id) 
	from orders
	where (NOT customer_id  in
		(select customer_id from customers)) OR customer_id is NULL;
		

select o.employee_id, o.ship_city, o.customer_id, o.order_id
	from orders o
		where ship_city = 
			(select e.city 
			 from employees e 
			 where e.employee_id = o.employee_id) ;
			 
select o.employee_id, e.employee_id, o.ship_city, o.customer_id, o.order_id
	from orders as "o", employees as  "e"
		where ship_city = e.city AND e.employee_id = o.employee_id;
		
select o.order_id, round((unit_price * quantity)::numeric, 2) AS "TOTAL"
	from orders o, order_details od
	where o.order_id = od.order_id
	and o.ship_country = 'France';
	
select suppliers.company_name, products.product_name 
	from suppliers, products 
	where suppliers.supplier_id = products.supplier_id 
		AND suppliers.country = 'Japan';
		
Select last_name, first_name,
		sum((select unit_price*quantity from order_details ord 
		 where ord.order_id = o.order_id )) as "total"
	from orders o, employees em 
	where em.employee_id = o.employee_id
	group by last_name, first_name
	order by 1,2; 
	

Select  last_name, first_name,
		sum((select unit_price*quantity from order_details ord 
		 	where ord.order_id in 
				(select order_id from orders o, employees 
				where employees.employee_id = o.employee_id )) )
		as "total"
	from employees em 
	group by em.employee_id 
	order by 1,2; 

Select last_name, first_name, sum(unit_price*quantity) as "total"
	from orders o, employees em, order_details ord 
	where em.employee_id = o.employee_id AND ord.order_id = o.order_id 
	group by em.employee_id
		HAVING  sum(unit_price*quantity) < 100000
	order by 1,2;
	
select last_name, first_name, sum (unit_price*quantity) as "total"
	from employees join orders ON orders.employee_id = employees.employee_id 
		join order_details ON order_details.order_id = orders.order_id
	group by last_name, first_name 
	order by 3
	limit  5;
	
select count(distinct customer_id) from orders;

select count(distinct customer_id) from customers;

select c.customer_id from customers c 
	where c.customer_id NOT in (select o.customer_id from orders o);
	
select customers.customer_id 
	from orders right outer join customers on 
		orders.customer_id = customers.customer_id
	where orders.customer_id is NULL; 
	
select emp.employee_id, ord.employee_id, ord.order_id 
	from employees emp 
		left outer join orders ord on ord.employee_id = emp.employee_id
	where order_id is NULL;

select distinct employee_id from employees;
select distinct employee_id from orders;

select ord.customer_id 
	from orders ord 
	where ord.customer_id not in (select customer_id from customers);

select ord.customer_id 
	from orders ord left outer join 