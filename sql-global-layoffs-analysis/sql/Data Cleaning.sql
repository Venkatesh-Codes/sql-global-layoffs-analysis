-- Layoffs Data Cleaning(SQL Project)

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022


select * from layoffs;

-- 1) Remove Duplicates
-- 2) Standardize the Data
-- 3) Handle Null or Blank Values
-- 4) Remove Unwanted columns


-- Create new table like layoffs and copy & paste the data into new table

create table layoffs_staging
select * from layoffs; 

 select * from layoffs_staging;
 
 
 -- 1) Removing Duplicates
 
-- Find Duplicates

with cte as 
(
	select *, row_number() 
    over(partition by company, location, industry, total_laid_off, 
			percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
			from layoffs_staging
    
)
select * from cte
where row_num>1;

-- Adding New column (row_num) to the previous table  and create a new table , It's name is layoffs_staging1
CREATE TABLE `layoffs_staging1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert the values into layoffs_staging1 table
 
insert into layoffs_staging1
select *, row_number() 
    over(partition by company, location, industry, total_laid_off, 
			percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
			from layoffs_staging;

select * from layoffs_staging1;

-- Remove/Delete the Duplicate rows using row_num 
delete from layoffs_staging1
where row_num>1;

select * from layoffs_staging1
where row_num>1;

-- Standardizing  Data

select * from layoffs_staging1;

select distinct company
from layoffs_staging1
order by 1;

-- Remove any space before and after the company name for readability perpose

update layoffs_staging1
set company=trim(company);

select * from layoffs_staging1;

select distinct industry
from layoffs_staging1
order by 1;

-- Find any Closest Values

select * from layoffs_staging1
where industry like "Crypto%";

-- Update the Closest values

update layoffs_staging1
set industry='Crypto'
where industry like 'Crypto%';

select * from layoffs_staging1;

select distinct country
from layoffs_staging1
order by 1;

-- Find any Closest Values

select * from layoffs_staging1
where country like 'United States.%';

-- Update the Closest values

update layoffs_staging1
set country='United States'
where country like 'United States%';

select * from layoffs_staging1;

-- I observed the date column looks like different

select `date` from layoffs_staging1;

-- Update the date column into the date formate

update layoffs_staging1
set `date`=str_to_date(`date`,'%m/%d/%Y');

-- still i notice date column data type is text, so i convert the text to date data type

alter table layoffs_staging1
modify `date` date;

select * from layoffs_staging1;

-- Handle Null Or Blank Values

select * from layoffs_staging1;

-- I observed the some null value columns

select * from layoffs_staging1
where total_laid_off is null and percentage_laid_off is null;

-- Here i observed some bank and null values
select * from layoffs_staging1
where industry is null ;

-- change balnk values to null values

update layoffs_staging1
set industry=null
where industry='';

-- Here i notice some company names are same,  but in some rows they have industry names, remaining doesn't have industry names

select * from layoffs_staging1
where company='Airbnb';

select t1.industry,t2.industry from layoffs_staging1 t1
join layoffs_staging1 t2 on
t1.company=t2.company and t1.location=t2.location
where t1.industry is null and t2.industry is not null;

-- Based on the above query i did update the industry names based on company names

update layoffs_staging1 t1
join layoffs_staging1 t2 on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null and t2.industry is not null;
 
select * from layoffs_staging1;

-- Here i deleted the null values which following columns both have null values

delete from layoffs_staging1
where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging1;

-- Here i delete the unwanted columns from the table

alter table layoffs_staging1
drop column row_num;

select * from layoffs_staging1;
