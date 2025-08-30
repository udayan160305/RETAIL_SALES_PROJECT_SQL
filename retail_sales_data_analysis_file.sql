
--creation of retail_sales table and importing data into it.

CREATE TABLE retail_sales(
transactions_id INT,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT);

-- data cleaning by estimation and removal of null values

select * from retail_sales
where
	transactions_id is null
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
	cogs is null
	or
	total_sale is null;
	
	--deleting the null data records

	delete from retail_sales
	where
		transactions_id is null
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
		cogs is null
		or
		total_sale is null;

		
 -- Exploratory data analysis

 
--total number of sales
select count(*) as total_sales from retail_sales;

--total number of unique customers
select count(distinct(customer_id)) from retail_sales;

--list of customer id of customers who have ordered more than once

select customer_id , count(transactions_id)as count_of_transactions
from retail_sales
group by customer_id
having count(transactions_id)>1
order by count(transactions_id) desc;

--query for finding the top 5 customers who have ordered the most number of times

select * from
(select customer_id ,count(transactions_id)as count_of_transactions,
dense_rank () over(order by count(transactions_id) desc) as rnk
from retail_sales
group by customer_id)
where rnk<5;

--query to retrieve all the transactions where the category is clothing and the quantity sold is more than 4 units in the month of November,2022.

select * from retail_sales
where category = 'Clothing'
and to_char(sale_date, 'yyyy-mm')= '2022-11'
and quantiy>=4

--query to calculate total sales and total number of orders for each category

select category, sum(total_sale) as total_sales , count(*) as total_orders
from retail_sales
group by category; 

--query to find the average age (upto two decimal places) of the customers who bought items from the beauty category

select round(avg(age),2) as average_age
from retail_sales
where category='Beauty';

--query to find all the transactions of electronics category where the total_sale is greater than 1000.

select * from retail_sales
where total_sale >= 1000
and category='Electronics';

--query to find total number of transactions made by each gender in each category

select category , gender , count(transactions_id) as total_transactions
from retail_sales
group by category , gender
order by total_transactions desc;

--query to calculate the average sales for eacch month and finding out the best selling month of each year

select * from
(select
extract(year from sale_date)as year,
extract(month from sale_date)as month,
avg(total_sale) as average_sales,
rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc)as rank
from retail_sales
group by year, month)
where rank=1;

--query to find the top 5 customers based on the highest total sales

select customer_id , sum(total_sale),
rank() over(order by sum(total_sale) desc)as rank
from retail_sales
group by customer_id
limit 5;

--query to find the number of unique customers who bought items from each category.

select category , count(customer_id) as count_of_all_customers , count(distinct(customer_id)) as count_of_unique_customers
from retail_sales
group by category;

--query to find all the customer ids of customers who have bought items from all three categories

select customer_id from retail_sales
group by customer_id 
having count(distinct(category))=3;

--query to create each shift and number of orders in each shift(morning , afternoon and evening).

with hourly_sale
as(
select * , case when extract(hour from sale_time) <12 then 'MORNING'
				when extract(hour from sale_time) between 12 and 17 then 'AFTERNOON'
				else 'EVENING'
			end as shift
	from retail_sales
   )
select shift, count(*)as total_orders
from hourly_sale
group by shift