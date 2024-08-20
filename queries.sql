4 урок:

SELECT COUNT(customer_id) AS customers_count -- подсчет общего кол-ва покупателей из таблицы customers
FROM customers;
----------------------------------------------------------------------------------------------------------------
5 урок:

1. top_10_total_income:

with sales_price as (
	select sales_id,
	sales_person_id,
	customer_id,
	sales.product_id,
	quantity,
	products.price,
	products.price * quantity as total -- подсчет выручки с каждой продажи
from sales
inner join products on sales.product_id = products.product_id -- джоин таблицы products для добавления столбца products.price
), -- добавление к таблице sales выручки по каждой продаже, далее станет основной таблицей для работы на этом уроке
sellers_list as (
	select employee_id, CONCAT(first_name, ' ', last_name) as seller from employees -- конкатенация полного имени продавца
)

select seller, -- полное имя продавца
	count(sales_id) as operations, -- подсчет кол-ва операций продавца
	floor(sum(total)) as income -- подсчет продаж каждого продавца с округлением до целого числа
from sales_price
inner join sellers_list on sellers_list.employee_id = sales_price.sales_person_id -- джоин cte sellers_list для указания имени продавца
group by seller -- группировка по имени продавца
order by income desc; -- сортировка по выручке по убыванию

2. lowest_average_income:

with sales_price as (
	select sales_id,
	sales_person_id,
	customer_id,
	sales.product_id,
	quantity,
	products.price,
	products.price * quantity as total -- подсчет выручки с каждой продажи
from sales
inner join products on sales.product_id = products.product_id -- джоин таблицы products для добавления столбца products.price
), -- добавление к таблице sales выручки по каждой продаже, далее станет основной таблицей для работы на этом уроке

average_sales as (
	select avg(total) as avg_sales from sales_price -- средняя выручка по всем продавцам
),

sellers_list as (
	select employee_id, CONCAT(first_name, ' ', last_name) as seller, -- конкатенация полного имени продавца
		floor(avg(total)) as average_income -- подсчет средней выручки по каждому продавцу
	from employees 
	inner join sales_price on sales_price.sales_person_id = employees.employee_id -- джоин таблицы sales для доступа к столбцу total для подсчета средней выручки по каждому продавцу
	group by employee_id, seller -- группировка по продавцу и айди
)

select seller,
	average_income
from sellers_list
cross join average_sales -- джоин средней выручки по всем продавцам
where average_income < avg_sales -- фильтр на выручку каждого продавца которая меньше общей средней выручки по всем продавцам
order by average_income asc; -- сортируем по выручке по возрастанию


3. day_of_the_week_income:


with sales_price as (
	select sales_id,
	sales_person_id,
	customer_id,
	sales.product_id,
	quantity,
	products.price,
	products.price * quantity as total, -- подсчет выручки с каждой продажи
	extract(dow, sale_date) as day_of_week -- указания дня недели в численном формате
from sales
inner join products on sales.product_id = products.product_id -- джоин таблицы products для добавления столбца products.price
), -- добавление к таблице sales выручки по каждой продаже, далее станет основной таблицей для работы на этом уроке 

sellers_list as (
	select employee_id, CONCAT(first_name, ' ', last_name) as seller from employees -- конкатенация полного имени продавца
)

select seller,
	case -- преобразование номера дня недели в название дня недели
		when day_of_week = 0 then 'monday'
		when day_of_week = 1 then 'tuesday'
		when day_of_week = 2 then 'wednesday'
		when day_of_week = 3 then 'thursday'
		when day_of_week = 4 then 'friday'
		when day_of_week = 5 then 'saturday'
		when day_of_week = 6 then 'sunday'
	end
	,
	floor(SUM(total)) as income -- выручки по дню недели
from sales_price
inner join sellers_list on sellers_list.employee_id = sales_price.sales_person_id -- джоин таблицы sellers_list для указания имени продавца
group by seller, day_of_week -- группировка по имени продавца и дню недели
order by day_of_week, seller; -- сортировка по дню недели и имени продавца

6 урок:

