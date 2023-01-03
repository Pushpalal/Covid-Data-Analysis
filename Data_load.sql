-- Loading tables

-- First table - Covid deaths data
create table covid_deaths(iso_code varchar, continent varchar, location varchar, 
			date timestamp, population float, total_cases float, new_cases float, new_cases_smoothed float, 
			total_deaths float, new_deaths float, new_deaths_smoothed float, total_cases_per_million float,	
			new_cases_per_million float, new_cases_smoothed_per_million float, total_deaths_per_million float,	
			new_deaths_per_million float, new_deaths_smoothed_per_million float, reproduction_rate float, 
			icu_patients float, icu_patients_per_million float,	hosp_patients float, hosp_patients_per_million float, 
			weekly_icu_admissions float, weekly_icu_admissions_per_million float, weekly_hosp_admissions float,	
			weekly_hosp_admissions_per_million float);

copy covid_deaths
from 'C:\Users\Public\covid_deaths.csv'
with (format csv, header true);

-- Second table - Covid vaccinations data
create table covid_vacc(iso_code varchar, continent varchar, location varchar, date timestamp, new_tests float, total_tests float, total_tests_per_thousand float, 
new_tests_per_thousand float, new_tests_smoothed float, new_tests_smoothed_per_thousand float, positive_rate float, tests_per_case float, 
tests_units varchar, total_vaccinations float, people_vaccinated float, people_fully_vaccinated float, total_boosters float, new_vaccinations float, 
new_vaccinations_smoothed float, total_vaccinations_per_hundred float, people_vaccinated_per_hundred float, 
people_fully_vaccinated_per_hundred float, total_boosters_per_hundred float, new_vaccinations_smoothed_per_million float, 
new_people_vaccinated_smoothed float, new_people_vaccinated_smoothed_per_hundred float, tringency_index float, population_density float, 
median_age float, aged_65_older float, aged_70_older float, gdp_per_capita float, extreme_poverty float, cardiovasc_death_rate float, 
diabetes_prevalence float, female_smokers float, male_smokers float, handwashing_facilities float, hospital_beds_per_thousand float, 
life_expectancy float, human_development_index float, excess_mortality_cumulative_absolute float, excess_mortality_cumulative float, 
excess_mortality float, excess_mortality_cumulative_per_million float);

copy covid_vacc
from 'C:\Users\Public\covid_vaccinations.csv'
with (format csv, header true);


alter table covid_deaths
alter column date type date;

alter table covid_vacc
alter column date type date;

select iso_code, continent, location, date, population, total_cases from covid_deaths
order by date desc;

delete from covid_deaths
where date in ('2022-11-08', '2022-11-07', '2022-11-06', '2022-11-05', '2022-11-04', '2022-11-03', 
			   '2022-11-02', '2022-11-01')
returning *;

select * from covid_vacc
order by date desc;

delete from covid_vacc
where date in ('2022-11-09', '2022-11-08', '2022-11-07', '2022-11-06', '2022-11-05', '2022-11-04', '2022-11-03', 
			   '2022-11-02', '2022-11-01')
returning *;












































































