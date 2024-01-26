drop view top_customers;
create view top_customers as
	select company_name, total, 
	case 
		when total < 40000 then 'needs focus'
		when total < 11500 then 'average'
		else 'outstanding'
	end "assesment"
		from (select company_name, sum (quantity*unit_price) as "total"
		from customers cus join orders o 
			on cus.customer_id = o.customer_id join order_details ord
				on o.order_id = ord.order_id 
		group by company_name 
		order by 2 desc
		limit 10);
select * from top_customers;
			
			
select company_name, sum(unit_price * units_in_stock) 
		from products join suppliers on products.supplier_id = suppliers.supplier_id
		group by company_name
	union 
		select '1totalewwdweds', sum(unit_price*units_in_stock)
			from products;
			
			
