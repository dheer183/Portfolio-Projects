select * 
from `metal-seeker-379918.Covid.covid_vaccination`
order by 3,4 ;

select location, date, total_cases, new_cases, total_deaths, population
from `metal-seeker-379918.Covid.covid_death`
where location = "United States"
order by 1,2;

-- Looking at total cases vs total deaths--
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
from `metal-seeker-379918.Covid.covid_death`
where location = "India"
order by 1,2;

--Looking at total cases vs population

select location, date, total_cases, population, (total_cases/population)*100 as Death_percentage
from `metal-seeker-379918.Covid.covid_death`
where location = "India"
order by 1,2;

--Highest infection Rate

select Location, Population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as Percentage_Population_Infection_Rate
from `metal-seeker-379918.Covid.covid_death`
where location = "United States"
group by location, population
order by Percentage_Population_Infection_Rate DESC;

--Showing Countries with highest death count per population

select Location, Population, max(total_deaths) as total_death, max((total_deaths/population))*100 as total_death_percentage
from `metal-seeker-379918.Covid.covid_death`
where continent is not null
group by location, population
order by total_death DESC;

--Breaking things down by continent

select continent, max(total_deaths) as total_death, max((total_deaths/population))*100 as total_death_percentage
from `metal-seeker-379918.Covid.covid_death`
where continent is not null
group by continent
order by total_death DESC;

-- Showing the continent with highest death counts

select continent, max(total_deaths) as total_death
from `metal-seeker-379918.Covid.covid_death`
where continent is not null
group by continent
order by total_death DESC;

-- Global Numbers

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths
from `metal-seeker-379918.Covid.covid_death`
where continent is not null
--group by date
order by 1,2;

--Joining tables Total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum( vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.Date) as Rolling_people_vaccinated
from `metal-seeker-379918.Covid.covid_death` as dea
join `metal-seeker-379918.Covid.covid_vaccination` as vac
    on dea.location = vac.location
    and dea.date = vac.date
order by 2,3;

--CTE
WITH PopvsVac AS (
  SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
  FROM 
    `metal-seeker-379918.Covid.covid_death` dea
  JOIN 
    `metal-seeker-379918.Covid.covid_vaccination` vac
  ON 
    dea.location = vac.location
    AND dea.date = vac.date
  -- ORDER BY 2, 3
)
SELECT *,(Rolling_people_vaccinated/Population)*100 FROM PopvsVac;






