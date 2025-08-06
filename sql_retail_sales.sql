-- sql retail sales analysis - p1

drop table if exists retail_sales;
create table retail_sales
(transactions_id INT primary key,
sale_date date,
sale_time time,
customer_id	int,
gender varchar(15),
age	int,
category varchar(15),	
quantiy int,
price_per_unit float,
cogs float,	
total_sale float

);

select * from retail_sales;

select  count(*) from retail_sales;
-- data cleaning
select * from retail_sales
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;


delete from retail_sales
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

-- Data exploration
-- How many sales we have?
select  count(*) from retail_sales;

--How many unique customers we have?
select count(distinct(customer_id)) from retail_sales;


-- Data analysis & business key problems & answers


--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
select * from retail_sales 
where sale_date = '2022-11-05';

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
select * from retail_sales
where category = 'Clothing' and 
to_char(sale_date,'yyyy-mm') = '2011-11'
and quantiy >=4;


--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale) as total_sale,count(*) from retail_sales
group by category


--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) from retail_sales
where category = 'Beauty';

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales 
where total_sale > 1000;

--Q.6 Write a SQL query to find the average number of transactions (transaction_id) made by each gender in each category.

select category,gender,count(transactions_id) from retail_sales
group by category,gender

--Q.7 Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.


select sale_year,sale_month,average_sale
from(select extract(year from sale_date) as sale_year,
extract(month from sale_date) as sale_month,
avg(total_sale) as average_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2) as t1 
where rank = 1


--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id,sum(total_sale) as highest_sales from retail_sales
group by customer_id
order by highest_sales desc limit 5 

--Q.9 Write a SQL query to find the total number of unique customers who purchased items from each category.
select category,count(distinct(customer_id)) from retail_sales
group by category

--Q.10 Write a SQL query to create each shift and number of orders (Example: Morning < 12, Afternoon Between 12 & 17, Evening > 17)
with final as (SELECT transactions_id,
  EXTRACT(HOUR FROM sale_time) AS shifts,
  CASE 
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening'
    ELSE 'None'
  END AS shifts_category
FROM retail_sales)
select count(transactions_id),shifts_category
from final
group by shifts_category;

