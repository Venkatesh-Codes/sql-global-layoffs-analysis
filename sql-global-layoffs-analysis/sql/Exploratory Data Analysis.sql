-- Layoffs Exploratory Data Analysis (EDA)(SQL Project)

select * from layoffs_staging1;

-- Here I could find the maximum and minmum values  of total_laid_off and percentage_laid_off

select max(total_laid_off),min(total_laid_off),max(percentage_laid_off),min(percentage_laid_off) from layoffs_staging1;

-- Here I Could find the total values where persentage_laid_off=1

select * from layoffs_staging1
where percentage_laid_off=1
order by funds_raised_millions desc;

-- I could find the total laid off people in each company 

select company,sum(total_laid_off)
from layoffs_staging1
group by company
order by 2 desc;

-- I observed the starting and ending laid_off dates in the taken data set

select min(`date`),max(`date`)
from layoffs_staging1;

-- Here I notice industry wise total_laid_offs

select industry,sum(total_laid_off)
from layoffs_staging1
group by industry
order by 2 desc;

-- Country wise total_laid_offs

select country,sum(total_laid_off)
from layoffs_staging1
group by country
order by 2 desc;

-- Every Date wise total_laid_offs

select `date`,sum(total_laid_off)
from layoffs_staging1
group by `date`
order by 1 desc;

-- Every Year wise total_laid_offs

select year(`date`),sum(total_laid_off)
from layoffs_staging1
group by year(`date`)
order by 1 desc;

-- Every stage wise total_laid_offs

select stage,sum(total_laid_off)
from layoffs_staging1
group by stage
order by 2 desc;

select * from layoffs_staging1;

-- -- Every Year & Month wise total_laid_offs

select substring(`date`,1,7) `Month`,sum(total_laid_off)
from layoffs_staging1
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by 1;

-- Here i observed year & month wise Rolling Total total_laid_offs

with Rolling_total as
(
	select substring(`date`,1,7) `Month`,sum(total_laid_off) total_off
	from layoffs_staging1
	where substring(`date`,1,7) is not null
	group by substring(`date`,1,7)
	order by 1
	
)

select `Month`,total_off, sum(total_off) over(order by `Month`) total
from Rolling_total;

-- Top 5 laid_off companies in everey year with company, total_laid_off, year values

with company (Company,Years,total_off) as
(
	select company,year(`date`),sum(total_laid_off)
    from layoffs_staging1
	where year(`date`) is not null
    group by company,year(`date`)
    order by year(`date`)
   

),
company_year as
(
	select *,dense_rank() over(partition by Years order by Company) rank_num from company
   
    
)
select * from company_year
where rank_num<=5
order by 2 desc;










