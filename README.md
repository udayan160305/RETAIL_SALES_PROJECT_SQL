# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.


-- data cleaning by estimation and removal of null values
```sql
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
```
	
 --deleting the null data records
```sql
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
```
		
 -- Exploratory data analysis

 
--total number of sales
```sql
select count(*) as total_sales from retail_sales;
```
--total number of unique customers
```sql
select count(distinct(customer_id)) from retail_sales;
```
--list of customer id of customers who have ordered more than once
```sql
select customer_id , count(transactions_id)as count_of_transactions
from retail_sales
group by customer_id
having count(transactions_id)>1
order by count(transactions_id) desc;
```
--query for finding the top 5 customers who have ordered the most number of times
```sql
select * from
(select customer_id ,count(transactions_id)as count_of_transactions,
dense_rank () over(order by count(transactions_id) desc) as rnk
from retail_sales
group by customer_id)
where rnk<5;
```
--query to retrieve all the transactions where the category is clothing and the quantity sold is more than 4 units in the month of November,2022.
```sql
select * from retail_sales
where category = 'Clothing'
and to_char(sale_date, 'yyyy-mm')= '2022-11'
and quantiy>=4
```
--query to calculate total sales and total number of orders for each category
```sql
select category, sum(total_sale) as total_sales , count(*) as total_orders
from retail_sales
group by category; 
```
--query to find the average age (upto two decimal places) of the customers who bought items from the beauty category
```sql
select round(avg(age),2) as average_age
from retail_sales
where category='Beauty';
```
--query to find all the transactions of electronics category where the total_sale is greater than 1000.
```sql
select * from retail_sales
where total_sale >= 1000
and category='Electronics';
```
--query to find total number of transactions made by each gender in each category
```sql
select category , gender , count(transactions_id) as total_transactions
from retail_sales
group by category , gender
order by total_transactions desc;
```
--query to calculate the average sales for eacch month and finding out the best selling month of each year
```sql
select * from
(select
extract(year from sale_date)as year,
extract(month from sale_date)as month,
avg(total_sale) as average_sales,
rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc)as rank
from retail_sales
group by year, month)
where rank=1;
```
--query to find the top 5 customers based on the highest total sales
```sql
select customer_id , sum(total_sale),
rank() over(order by sum(total_sale) desc)as rank
from retail_sales
group by customer_id
limit 5;
```
--query to find the number of unique customers who bought items from each category.
```sql
select category , count(customer_id) as count_of_all_customers , count(distinct(customer_id)) as count_of_unique_customers
from retail_sales
group by category;
```
--query to find all the customer ids of customers who have bought items from all three categories
```sql
select customer_id from retail_sales
group by customer_id 
having count(distinct(category))=3;
```
--Query to create each shift and number of orders in each shift(morning , afternoon and evening).
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.


## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

