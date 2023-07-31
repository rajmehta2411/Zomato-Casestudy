1) What is the total amount each customer spent on zomato?
  
SELECT a.user_id,SUM(b.price),total_amt_spent 
FROM sales a
JOIN product b 
ON a.product_id=b.product_id
GROUP BY a.user_id


2) How many days has each customer visited zomato?

select userid, count (distinct created date) distinct days 
from sales 
group by userid;


3) What was the first product purchased by each customer?

select * from
(select *,rank() over(partition by userid order by created_date ) rnk from sales) a where rnk=1


4)what is the most purchased item on the menu and how many times was it purchased by all customers?


select userid, count(product_id) cnt from sales where product_id =
(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by userid


5)Which item was the most popular for each customer?

select * from
(select *,rank() over(partition by userid order by cnt desc) rnk 
from
(select userid, product_id,count (product_id) cnt from sales 
group by userid,product_id)a)b
where rnk=1


6) Which item was purchased first by the customer after they became a member?

select * from
(select c.*,rank() over(partition by userid order by created_date ) rnk 
from
(select a.userid,a.created date, a.product_id,b.gold_ signup_date 
from sales a inner join
goldusers_signup b on a.useride=b.userid and created date>= gold_signup date) c) d 
where rnk=1;

 
7) Which item was purchased just before the custongr became a member

select * from
(select c.*,rank() over(partition by userid order by created_date desc ) rnk from
(select a.userid,a.created date, a.product_id,b.gold_signup_date 
from sales a inner join goldusers_signup b on a.userid and created date<=gold_signup_date) c) d 
where rnk=1;

 
8) What is the total orders and amount spent for each member before they became a menber?

select userid, count (created date) order _puchased, sum(price) total_amt_spent 
from
(select c.*,d.price from
(select a.userid,a.created date,a.product_id,b.gold_signup_date 
from sales a 
inner join
goldusers_signup b on a.userid=b.userid and created date<=gold_signup_date)c inner join product d on c.product_id=d.product_id)e
group by userid;


9) If buying each product generates points for eg 5rs-2 zomato point and each product has different purchasing points
for eg for pl 5rs-1 zomato point ,for p2 10rs-Szomato point and p3 Srs-1 zomato point.
calculate points collected by each customers and for wilch product most points heve been given till now

select userid, sum(total_points)*2.5,
 total_money_earned from
(select e.*,amt/points total_points from
(select d.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product id) c
GROUP BY userid,product_id)d)e)f 
GROUP BY userid;


10) In the first one year after a customer joins the gold program (including their join date) irrespective
of what the customer has purchased they earn 5 zomato points for every 10 rs spent who earned more 1 or 3
and what was their points earnings in thier first yr?

1 zp=2rupees,
0.5=1 rupee

select c.*,d.price*0.5 total points earned from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on a.userid=b.userid and created_date>=gold_signup_date and created datec<=DATEADD(year, 1,gold_signup_date))c
inner join product d on c.product_id=d.product_id;


11) rnk all the transaction of the customers

select *,rank() over(partition by userid order by created date ) rnk from sales;


12) rank all the transactions for each member whenever they are a zomato gold member for every non gold member transction mark as 'n',

select e.*,case when rnk=0 then 'na' else rnk end as rnkk from
(select c.*,cast((case when gold_signup_date is null then 0 else rank() over(partition by userid order by created_date desc) end) as varchar) as rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a left join
goldusers_signup b on a.userid-b.userid and created date>=gold_ signup_date)c)e;


