-- ** CREATING VIEWS FOR VISUALISATION PURPOSE IN TABLEAU **

--1

create view Overall_global_death_perc 
as
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
round((sum(new_deaths)*100/sum(new_cases))::numeric, 2)
as mortality_rate from covid_deaths
--where location = 'world'
where continent is not null;


--2

create view Overall_continental_death_perc 
as
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
round((sum(new_deaths)*100/sum(new_cases))::numeric, 2)
as mortality_rate from covid_deaths
where continent is null
and location in ('Asia', 'Africa', 'Europe', 'North America', 'South America', 'Oceania')
group by 1
order by 3 desc;


--3

create view Highest_infection_rate
as
select location, population, max(total_cases) as total_covid_cases, max(round((total_cases*100/population)::numeric,2)) 
as highest_infection_percentage
from covid_deaths 
where total_cases is not null and continent is not null
group by location, population
order by highest_infection_percentage desc;


--4

create view percent_population_infected_daywise
as
select location, population, date, max(total_cases) as total_covid_cases, max(round((total_cases*100/population)::numeric,2)) 
as percent_population_infected
from covid_deaths 
where total_cases is not null and continent is not null
group by location, population, date
order by percent_population_infected desc;


--5

create view Overall_vaccination_percent
as
WITH RollPeopVacc (location, population, Rolling_People_Vaccinated)
as (
	select cd.location, cd.population, SUM(cv.new_vaccinations) as Rolling_People_Vaccinated
	from covid_deaths cd 
	join covid_vacc cv on
	cd.location = cv.location 
	and cd.date = cv.date	
	where cd.continent is not null and cv.new_vaccinations is not null 
	group by 1, 2
	)
select sum(population) as Total_Population, sum(Rolling_People_Vaccinated) as Total_Vaccinations,
round((sum(Rolling_People_Vaccinated)*100/sum(population))::numeric, 2) 
as Percent_Vaccination from RollPeopVacc




