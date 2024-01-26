CREATE TABLE items  
(  
    itemID     INT           primary key, 
    itemcode   VARCHAR(5)    NULL, 
    itemname   VARCHAR(40)   NOT NULL DEFAULT ' ', 
    quantity   INT           NOT NULL DEFAULT 0, 
    price      DECIMAL(9,2)  NOT NULL DEFAULT 0 
  ); 
  
  INSERT INTO items 
	(SELECT productid,  
        concat(supplierid, categoryid,discontinued),  
  		productname, unitsinstock, unitprice  
	from products); 
	
select * from items;

drop table if exists items;

create table Items (
	item_id int not null,
	supplier_id int not null,
	item_name varchar(40) default ' ',
	quantity int not null default 0,
	price decimal(9,2) check (price < 1000),
	primary key (item_id),
	constraint fk_supplier foreign key (supplier_id) 
		references suppliers(supplier_id)
		on delete no action
);

INSERT INTO items 
	(SELECT product_id,  
        supplier_id, product_name, units_in_stock, unit_price  
	from products)
; 

select * from items order by 1;

select supplier_id from suppliers order by 1 desc;
insert into items values(79, 30, 'slon2', 50, 100);

delete from suppliers where supplier_id = 27;

alter table items
	rename to "altairs";
	
alter table "altairs"
	rename column "item_name" to "item_surnmane";
	
alter table "altairs"
	add column "co2 emisions" int not null default 1;
	
alter table "altairs"
	add column "nullcolumn" int default null;
	
update  "altairs"
	set "co2 emisions" = 
		(select item_id from 
		 	(select item_id, item_surnmane 
			 from altairs order by item_surnmane limit 1))
	where "co2 emisions" < 10;
select * from altairs;

insert into Altairs values (101, '1234', 
							'picy grillmates', 12,1.99, '1234');

update altairs 
	set price = price / 8 
	where supplier_id between 5 and 7;
	
	select * from altairs where supplier_id between 5 and 7;

truncate altairs;
drop table altairs;