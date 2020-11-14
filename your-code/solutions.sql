use publications;

select * from authors; -- au_id au_lname au_fname
select * from titles; -- title pub_id titile_id advance
select * from titleauthor; -- au_id title_id royaltyper
select * from sales; -- title_id
select * from roysched; -- title_id

-- Challenge 1
select titleauthor.au_id, sum(titles.advance * titleauthor.royaltyper / 100 + royalties.sales_royalty) as total
from titles
join titleauthor
on titles.title_id = titleauthor.title_id
join
(select titleauthor.title_id, titleauthor.au_id,
sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from titles
join sales
on titles.title_id = sales.title_id
join titleauthor
on titles.title_id = titleauthor.title_id
group by titleauthor.title_id, titleauthor.au_id
order by sales_royalty desc) royalties
on titleauthor.au_id=royalties.au_id and titleauthor.title_id =  royalties.title_id 
group by titleauthor.au_id
order by total desc
limit 3;


-- CHALLENGE 2

-- Step 1
drop table table_lab;
create temporary table table_lab
select t.title_id,ta.au_id,
round((t.advance * ta.royaltyper / 100), 2) as advance,
round((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),2) as sales_royalty
from sales s
left join titles t 
on s.title_id = t.title_id
left join titleauthor ta 
on t.title_id = ta.title_id;

SELECT * from table_lab;

-- Step 2: Aggregate the total royalties for each title and author
drop table if exists table_lab2;
create temporary table table_lab2
select title_id, au_id,
sum(sales_royalty) as total_royalty,
round(avg(advance)) as advance 
from table_lab
group by title_id , au_id;

select * from table_lab2;

-- Step 3
create temporary table table_lab3
select au_id, sum(total_royalty + advance) as total_author_prophit
from table_lab2
group by au_id
order by total_author_prophit desc
LIMIT 3;

-- Challenge 3
drop table most_profiting_authors;
create table most_profiting_authors (
id int auto_increment,
au_id varchar(255),
total_author_prophit int,
PRIMARY KEY (id)
);

insert into most_profiting_authors (au_id, total_author_prophit)
select au_id, total_author_prophit
from table_lab3;

select * from most_profiting_authors;











   





