create database if not exists intquery;

select * from hr_emp;
show columns from hr_emp;

alter table hr_emp
modify hire_date date;

create table ord_data(
order_id int not null,
order_date text not null,
name text not null,
product text not null,
sale_price decimal(20,5) not null,
quantity int not null);

select * from ord_data;

show columns from ord_data;

update ord_data
set order_date = str_to_date(order_date, "%d-%m-%Y");

alter table ord_data
modify order_date date;

select * from hr_emp;
select * from ord_data;

-- 1.	Write a query to find all employees whose salaries exceed the company’s average salary

select * from hr_emp where salary > (Select avg(salary) from hr_emp);

select avg(salary) from hr_emp;

-- 2.	Write a query to retrieve all the name of the employees who work in the same department as ‘Aman Sharma’.

select * from hr_emp where first_name = 'Aman' and last_name = 'Sharma';
select * from hr_emp where department_id = 50;

select * from hr_emp where department_id = (select department_id from hr_emp where first_name = 'Aman' and last_name = 'Sharma')

-- 3.	Write a query to display the second highest salary from the employees table without using the max function twice.

Select first_name, last_name, salary, department_id from hr_emp
where salary < (select max(salary) from hr_emp)
limit 1;

select salary from hr_emp
order by salary DESC;



-- 4.	Write a query to list employees who joined the company within the last 12 months

select max(hire_date) from hr_emp;

select * from hr_emp where hire_date BETWEEN
date_sub('2001-03-19', interval 12 month) and '2001-03-19';

select * from hr_emp where hire_date between date_sub( ( select max(hire_date) from hr_emp),
interval 12 month) and (select max(hire_date) from hr_emp);


-- 5.	Write a query to find all customers who have placed more than 5 orders.

select * from ord_data;

select name, product, count(order_id) as Order_count
from ord_data
group by name, product
having Order_count > 5
order by Order_count DESC;

select name, count(order_id) as Order_count
from ord_data
group by name
having Order_count > 200
order by Order_count DESC;


-- 6.	Write a query to count the total number of orders placed by each customer.

select name, count(order_id) as Total_orders
from ord_data
group by name
order by Total_orders DESC;

-- 7.	Write a query to calculate the total sale amount for each product.

select * FROM ord_data;

select product, sum(sale_price * quantity) as Total_sales
from ord_data
group by product
order by Total_sales DESC;

-- 8.	Write a query to list all the products that have never been sold

SELECT product, sum(quantity) as Total_orders from ord_data
group by product
order by Total_orders DESC;


select product from ord_data
group by product
having sum(quantity) = 0;


-- 9.	Write a query to identify the top customers who have not placed any orders in the past year.


select max(order_date) from ord_data;

select name, product, sum(quantity) from ord_data
where order_date between date_sub(( select max(order_date) from ord_data),
interval 12 month) and (select max(order_date) from ord_data)
group by name, product
having sum(quantity) = 0;

-- 10.	Write a query to remove duplicate rows from a table.

select * from ord_data;

select order_id, order_date, name, product, sale_price, quantity, COUNT(*) as count
from ord_data
group by order_id, order_date, name, product, sale_price, quantity
having count(*)>1;

-- delete the duplicate row

create table ord_data_unique as select order_id, order_date, name, product, sale_price, quantity
from ord_data
group by order_id, order_date, name, product, sale_price, quantity;
drop table ord_data;

select * from ord_data;
select * from ord_data_unique;

alter table ord_data_unique rename to ord_data;

select * from ord_data;























select * from ord_data;
WITH CTE AS (
    SELECT 
        *, 
        ROW_NUMBER() OVER (PARTITION BY order_id, order_date, product, sale_price, quantity
        ORDER BY (SELECT NULL)) AS row_num
    FROM 
        ord_data
)
DELETE FROM CTE
WHERE row_num > 1;


SELECT 
    order_id, 
    order_date, name, product, sale_price, quantity, 
    -- Include other columns as needed
    COUNT(*) AS count
FROM 
    ord_data
GROUP BY 
    order_id, 
    order_date, name, product, sale_price, quantity
    -- Include other columns as needed
HAVING 
    COUNT(*) > 1;

create table ord_data(
order_id int not null,
order_date text not null,
name text not null,
product text not null,
sale_price decimal(20,5) not null,
quantity int not null);

select * from ord_data;

show columns from ord_data;
--
update ord_data
set order_date = str_to_date(order_date, "%d-%m-%Y");

alter table ord_data
modify order_date date;









