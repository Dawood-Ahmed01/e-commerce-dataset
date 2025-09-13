--1. Total customers kitne hain? Gender aur country ke hisaab se breakdown.
select 
	country,
	gender,
	count(distinct customer_id) as total_customers 
from customers
group by 1 , 2;

--2. Har month ka total sales revenue. Kis month me peak sales hui?
with monthly_sale as(
select 
	date_trunc('Month' , o.order_date) as month,
	sum(od.total_amount) as total_sales
from orders o
join order_details od on od.order_id = o.order_id
group by 1
)
select 
	to_char(month , 'Mon YYYY') as months,
	total_sales
from monthly_sale
order by month;

--3. Revenue ke hisaab se top 5 products kaun se hain?
select 
	p.product_name,
	p.category,
	sum(od.total_amount) as total_revenue
from products p
join order_details od on od.product_id = p.product_id 
group by 1 , 2
order by 3 desc 
limit 5;

--4. Har product category ka total sales me % share.
select 
	p.category,
	sum(od.total_amount) as total_sales,
	round(
	sum(od.total_amount) * 100/sum(sum(od.total_amount)) over() ,2)
	as revenue_contri
from products p 
join order_details od on od.product_id = p.product_id
group by 1;

--5. Har order ka average revenue kitna hai?
SELECT 
   round(
   		avg(order_total) ,2) as avg_order
 from ( select 
 			od.order_id,
			 sum(od.total_amount) as order_total
		from order_details od 
		group by 1);

--6. Customers ko classify karo:
select 	
	c.customer_id,
	c.name,
case 
	when count(order_id) = 1 then 'one time buyer'
	when count(order_id) >= 6 then 'Loyal buyer'
	else 'Repeat Buyer' end as status
from orders o 
left join customers c on o.customer_id = c.customer_id
group by 1 , 2
order by count(order_id) desc;

--7. Kaun sa payment mode sabse zyada use hota hai? Total revenue ka kitna % us se aata hai?
select 
	o.payment_mode,
	sum(od.total_amount) as total_sales,
	round(
	sum(od.total_amount) *100 / sum(sum(od.total_amount)) over() ,2)
	as revenue_contri
from orders o
join order_details od on od.order_id = o.order_id
group by 1 ;

--8. Top 10 customers jinhon ne sabse zyada kharcha kiya.
select 
	c.customer_id,
	c.name as customer_name,
	sum(od.total_amount) as total_spent
from customers c 
join orders o on o.customer_id = c.customer_id
join order_details od on od.order_id = o.order_id
group by 1 , 2
order by 3 desc
limit 10;

--9. Har region (North, South, East, West) ka sales comparison.
select
	o.region ,
	sum(od.total_amount) as total_sales
from orders o 
join order_details od on od.order_id = o.order_id
group by 1 
order by 2 desc;

--10 . Aise customers ki list jo pichle 6 months me koi order nahi kiya.
SELECT 
    c.customer_id,
    c.name AS customer_name
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
   AND o.order_date >= current_date - interval '6 months'
WHERE o.order_id IS NULL;
