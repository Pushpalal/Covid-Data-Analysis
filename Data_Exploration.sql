-- ** DATA EXPLORATION **

-- Deaths in India as a percentage of the total covid cases

select location, date, total_cases, total_deaths, round((total_deaths*100/total_cases)::numeric,2) 
as Death_percentage 
from covid_deaths 
where location = 'India' 
order by 4 desc;

-- COVID cases in India as a percentage of the total population 

select location, date, population, total_cases, round((total_cases*100/population)::numeric,2) as infection_percentage 
from covid_deaths 
where location = 'India' 
order by 1,2;

-- Sorting countries according to the highest death count

select location, max(total_cases) as total_cases, max(total_deaths) as total_deaths, 
round((max(total_deaths)*100/max(total_cases))::numeric, 2)
as mortality_rate from covid_deaths
where (continent is not null) and (total_deaths is not null)
group by 1
order by 3 desc;

-- Overall global death percentage 

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
round((sum(new_deaths)*100/sum(new_cases))::numeric, 2)
as mortality_rate from covid_deaths
where continent is not null;

--Overall death percentage according to continent

select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
round((sum(new_deaths)*100/sum(new_cases))::numeric, 2)
as mortality_rate from covid_deaths
where continent is null
and location in ('Asia', 'Africa', 'Europe', 'North America', 'South America', 'Oceania')
group by 1
order by 3 desc

-- Sorting countries according to the highest infection rate compared to population

select location, population, max(total_cases) as total_covid_cases, max(round((total_cases*100/population)::numeric,2)) 
as highest_infection_percentage
from covid_deaths 
where total_cases is not null and continent is not null
group by location, population
order by highest_infection_percentage desc;


-- Joining Table covid_deaths and Table covid_vacc on column 'location' snd column 'date'

select * from covid_deaths cd 
join covid_vacc cv on
cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null

-- Looking at total people vaccinated over the days

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (Partition by cd.location Order by cd.location, cd.date) as Rolling_People_Vaccinated
from covid_deaths cd 
join covid_vacc cv on
cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null

-- Total people vaccinated as percentage of population till 31st Oct 2022

WITH RollPeopVacc (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as (
	select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	SUM(cv.new_vaccinations) OVER (Partition by cd.location Order by cd.location, cd.date) as Rolling_People_Vaccinated
	from covid_deaths cd 
	join covid_vacc cv on
	cd.location = cv.location 
	and cd.date = cv.date
	where cd.location = 'India'
	--where cd.continent is not null
	)
select *, round((Rolling_People_Vaccinated*100/population)::numeric,2) as perc_peop_vaccinated
from RollPeopVacc

 --Sorting countries according to the highest vaccination counts till 31st Oct 2022

WITH RollPeopVacc (location, population, new_vaccinations, Rolling_People_Vaccinated)
as (
	select cd.location, cd.population, cv.new_vaccinations, 
	SUM(cv.new_vaccinations) OVER (Partition by cd.location) as Rolling_People_Vaccinated
	from covid_deaths cd 
	join covid_vacc cv on
	cd.location = cv.location 
	and cd.date = cv.date	
	where cd.continent is not null
	)
select location,population, coalesce(max(Rolling_People_Vaccinated),0) as total_vaccination_count, 
round((rolling_People_vaccinated*100/population)::numeric,2) as percentage_vaccination
from RollPeopVacc
group by 1,2,4
order by 3 desc;






















































































