-- Analysing Data From CovidDeaths and CovidVaccinations Tables

select  * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4;

select * 
from PortfolioProject..CovidVaccinations
where continent is not null
order by 3,4;

-- Exploring data

Select location, date, total_cases, new_cases,total_deaths, population
From PortfolioProject..CovidDeaths
Order By 1,2;


-- Looking at Total Cases Vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location='india'
Order By 1,2;

-- Looking at Total Cases Vs Population

Select location, date, population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location='india'
Order By 1,2;

-- Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group By location, population
Order By PercentPopulationInfected desc;


-- Showing Countries with Highest Death Count

Select location,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group By location
Order By TotalDeathCount desc;


--Showing Continent with Highest Death Count

Select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group By continent
Order By TotalDeathCount desc;


--Global Data 

--Percentage of deaths per case each day
Select date, sum(new_cases) as TotalCases, sum(CAST(new_deaths as int)) as TotalDeaths, round((sum(CAST(new_deaths as int))/sum(new_cases))*100,3) as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group By date
Order By 1,2;

--Total Death per Case percentage 
Select sum(new_cases) as TotalCases, sum(CAST(new_deaths as int)) as TotalDeaths, round((sum(CAST(new_deaths as int))/sum(new_cases))*100,3) as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
--Group By date
Order By 1,2;


-- Total Population Vs Vaccinations

Select D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(bigint,V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as PeopleVaccinatedSum
From PortfolioProject..CovidDeaths D
Join PortfolioProject..CovidVaccinations V
On D.location = V.location
and D.date = V.date
where D.continent is not null
Order By 1,2;


-- Percentage of People Vaccinated

--  Using TEMP TABLE

DROP TABLE IF EXISTS PercentPeopleVaccinated
CREATE TABLE PercentPeopleVaccinated
  (
	Continent NVARCHAR(255),
	Location NVARCHAR(255),
	Date datetime,
	Population numeric,
	New_Vaccinations numeric, 
	PeopleVaccinatedSum numeric
   );

Insert into PercentPeopleVaccinated
Select D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(bigint,V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as PeopleVaccinatedSum
From PortfolioProject..CovidDeaths D
Join PortfolioProject..CovidVaccinations V
On D.location = V.location
and D.date = V.date
where D.continent is not null

Select *, (PeopleVaccinatedSum/Population)*100 as PeopleVaccinatedPercent
from  PercentPeopleVaccinated
Order By 1,2;


