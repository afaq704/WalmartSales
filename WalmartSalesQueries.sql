---------------------------------------- Feature Engineering -----------------------------------------

-- time_of_day
select time,
(case
	when `time` between "00:00:00" and "12:00:00" then 'Morning'
    when `time` between "12:01:00" and "16:00:00" then 'Afternoon'
    else "Evening"
    end) as time_of_day
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day =(
	case
		when `time` between "00:00:00" and "12:00:00" then 'Morning'
		when `time` between "12:01:00" and "16:00:00" then 'Afternoon'
		else "Evening"
    end
);

-- day_name

select date, dayname(date) from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- month_name

select date, monthname(date) from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

----------------------------------------------------------------------------------------------------------

------------------------------------------------- Generic ------------------------------------------------

-- How many unique cities does the data have?

select distinct city from sales;

-- In which city is each branch?

select distinct city, branch from sales;

----------------------------------------------------------------------------------------------------------

------------------------------------------------- Product ------------------------------------------------

-- How many unique product lines does the data have?

select count(distinct product_line) from sales;

-- What is the most selling product line?

select payment, count(payment) as PaymentCount
from sales
group by payment
order by PaymentCount Desc;

-- What is the most selling product line?

select product_line, count(product_line) as SellingCount
from sales
group by product_line
order by SellingCount Desc;

-- What is the total revenue by month?

select month_name as Month, sum(total) as TotalRevenue
from sales
group by month
order by TotalRevenue desc;

-- What month had the largest COGS?

select month_name as Month, sum(cogs) as CogsCount
from sales
group by Month
order By CogsCount desc;

-- What product line had the largest revenue?

select product_line, sum(total) as Revenue
from sales
group by product_line
order by Revenue desc;

-- What is the city with the largest revenue?

select city, sum(total) as Revenue
from sales
group by city
order by Revenue desc;

-- What product line had the largest VAT?

select product_line, avg(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

select product_line, avg(total) as avg_total,
	CASE
		when avg(total) > (select avg(total) from sales) then "Good"
        else "Bad"
	end as remark
from sales
group by product_line;

    
-- Which branch sold more products than average product sold?

select branch, sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?

select gender, product_line, count(gender) as Total_Count
from sales
group by gender, product_line
order by Total_count desc;

-- What is the average rating of each product line?

select product_line, round(avg(rating),2) as Avg_rating
from sales
group by product_line
order by Avg_rating desc;


----------------------------------------------------------------------------------------------------------

------------------------------------------------- Sales --------------------------------------------------

-- Number of sales made in each time of the day per weekday 

select time_of_day, count(*) as total_sales
from sales
where day_name="Sunday"
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue?

select customer_type, sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Which city has the largest tax/VAT percent?

select city, avg(tax_pct) as VAT
from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?

select customer_type, avg(tax_pct) as VAT
from sales
group by customer_type
order by VAT desc;

----------------------------------------------------------------------------------------------------------

----------------------------------------------- Customer -------------------------------------------------

-- How many unique customer types does the data have?

Select distinct customer_type from sales;

-- How many unique payment methods does the data have?

select distinct payment from sales;

-- What is the most common customer type?


-- Which customer type buys the most?

select customer_type, count(*) as Customer_count
from sales
group by customer_type
order by Customer_count desc;

-- What is the gender of most of the customers?

select gender, count(*) as gender_count
from sales
group by gender
order by gender_count desc;

-- What is the gender distribution per branch?

select gender, count(gender)
from sales
where branch = "A"
group by gender;

-- Which time of the day do customers give most ratings?

select time_of_day, avg(rating) as rate
from sales
group by time_of_day
order by rate desc;

-- Which time of the day do customers give most ratings per branch?

select time_of_day, avg(rating) as rate
from sales
where branch = "B"
group by time_of_day
order by rate desc;

-- Which day of the week has the best avg ratings?

select day_name, avg(rating) as ratings
from sales
group by day_name
order by ratings desc;

-- Which day of the week has the best average ratings per branch?

select day_name, avg(rating) as ratings
from sales
where branch = "B"
group by day_name
order by ratings desc;
