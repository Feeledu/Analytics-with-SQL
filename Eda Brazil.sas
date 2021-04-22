/*FAVOUR ELEDU RETAKE*/

libname barc 'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data';

/**importing files**/
filename births'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\births.csv' encoding="utf-8";
proc import datafile=births out=births replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename deaths'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\deaths.csv' encoding="utf-8";
proc import datafile=deaths out=deaths replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename acci'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\accidents_2017.csv' encoding="utf-8";
proc import datafile=acci out=accidents_2017 replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run; 
filename airqu'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\air_quality_Nov2017.csv' encoding="utf-8";
proc import datafile=airqu out=air_quality_Nov2017 replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename airsta'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\air_stations_Nov2017.csv' encoding="utf-8";
proc import datafile=airsta out=air_stations_Nov2017 replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename bus'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\bus_stops.csv' encoding="utf-8";
proc import datafile=bus out=bus_stops replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename imminat'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\immigrants_by_nationality.csv' encoding="utf-8";
proc import datafile=imminat out=immigrants_by_nationality replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename imiage'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\immigrants_emigrants_by_age.csv' encoding="utf-8";
proc import datafile=imiage out=immigrants_emigrants_by_age replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;

filename imides1 'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\immigrants_emigrants_by_destination.csv' encoding="utf-8";
proc import datafile=imides1 out=immigrants_emigrants_by_destination replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename imides2'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\immigrants_emigrants_by_destination2.csv' encoding="utf-8";
proc import datafile=imides2 out=immigrants_emigrants_by_destination2 replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename imi_sex'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\immigrants_emigrants_by_sex.csv' encoding="utf-8";
proc import datafile=imi_sex out=immigrants_emigrants_by_sex replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename bby_nms'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\most_frequent_baby_names.csv' encoding="utf-8";
proc import datafile=bby_nms out=most_frequent_baby_names replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename frq_nms'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\most_frequent_names.csv' encoding="utf-8";
proc import datafile=frq_nms out=most_frequent_names replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename popu'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\population.csv' encoding="utf-8";
proc import datafile=popu out=population replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename trans'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\transports.csv' encoding="utf-8";
proc import datafile=trans out=transports replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;
filename unemp'C:\Users\feledu1\Desktop\S1\SQL\Retake\BRT_retake_data\unemployment.csv' encoding="utf-8";
proc import datafile=unemp out=unemployment replace  dbms=csv ;    delimiter = ",";    GETNAMES = YES; 
run;


/** Average accidents on the different days of the week**/

PROC SQL;
select Weekday, count(Mild_injuries) as No_of_accidents, sum(Mild_injuries) as Total_Mild_Injuries, sum(Serious_injuries) as Total_Serious_injuries
from ACCIDENTS_2017
group by Weekday
order by No_of_accidents desc
;
QUIT;

/** Average accidents on the different months of the year**/
PROC SQL;
select Month, count(Mild_injuries) as No_of_accidents, sum(Mild_injuries) as Total_Mild_Injuries, sum(Serious_injuries) as Total_Serious_injuries
from ACCIDENTS_2017
group by Month
order by No_of_accidents desc
;
QUIT;

/** Average accidents on the different times of the month**/
PROC SQL;
select Day, count(Mild_injuries) as No_of_accidents, sum(Mild_injuries) as Total_Mild_Injuries, sum(Serious_injuries) as Total_Serious_injuries
from ACCIDENTS_2017
group by Day
order by No_of_accidents desc
;
QUIT;

/** Average accidents on the different hours of the year**/
PROC SQL;
select Hour, count(Mild_injuries) as No_of_accidents, sum(Mild_injuries) as Total_Mild_Injuries, sum(Serious_injuries) as Total_Serious_injuries
from ACCIDENTS_2017
group by Hour
order by No_of_accidents desc
;
QUIT;

 /*Time of the day*/
PROC SQL; 
select Part_of_the_day, count(Mild_injuries) as No_of_accidents, sum(Mild_injuries) as Total_Mild_Injuries, sum(Serious_injuries) as Total_Serious_injuries
from ACCIDENTS_2017
group by Part_of_the_day
order by No_of_accidents desc
;
QUIT;
/** Day of the week with most serious injuries **/
PROC SQL;
select Weekday, sum(Serious_injuries) as Most_Serious_injuries	
from ACCIDENTS_2017
group by Weekday
having Most_Serious_injuries >= ALL (select sum(Serious_injuries)
from ACCIDENTS_2017
group by Weekday)			
;
QUIT;


/** Day of the week with least serious injuries **/
PROC SQL;
select Weekday, sum(Serious_injuries) as Least_Serious_injuries	
from ACCIDENTS_2017
group by Weekday
having Least_Serious_injuries <= ALL (select sum(Serious_injuries)
from ACCIDENTS_2017
group by Weekday)			
;
QUIT;


/** Total number of lives affected during the period **/
PROC SQL;
select Month, sum(Victims) as Nbr_victims_affected	
from ACCIDENTS_2017
group by Month
order by Nbr_victims_affected desc	
;
QUIT;

/** try to order the months **/
PROC SQL;
Select Month, Nbr_victims_affected
from 
(select Month, case when Month = 'January' then 1
			 when Month = 'February' then 2
			 when Month = 'March' then 3
			 when Month = 'April' then 4
			 when Month = 'May' then 5
			 when Month = 'June' then 6
			 when Month = 'July' then 7
			 when Month = 'August' then 8
			 when Month = 'September' then 9
			 when Month = 'October' then 10
			 when Month = 'November' then 11
			 when Month = 'December' then 12
		end as Months, sum(Victims) as Nbr_victims_affected	
from ACCIDENTS_2017
group by Month
)
order by Months
;
QUIT;



/*Link the accidents and air quality data to the death dataset*/ 

/*Inspecting air_quality_Nov2017 and air_stations_Nov2017 columns*/ 
proc sql;
select distinct Station
from air_quality_Nov2017
;
quit;

proc sql;
select distinct Station
from air_stations_Nov2017
;
quit;


/*Merge air quality to stations data*/ 
proc sql;
select ass.Station, ass.District_Name, round(avg(aq.O3_Value)) as O3_Value, round(avg(aq.NO2_Value)) as NO2_Value, round(avg(aq.PM10_Value)) as PM10_Value
from air_quality_Nov2017 as aq, air_stations_Nov2017 as ass
where aq.Station = ass.Station
/* and aq.O3_Value is NOT NULL &  aq.NO2_Value is NOT NULL & aq.PM10_Value is NOT NULL*/
group by ass.Station, ass.District_Name
;
quit;
/*Final Merge */ 
proc sql;
select ass.District_Name as District_Name, round(avg(aq.O3_Value)) as O3_Value, round(avg(aq.NO2_Value)) as NO2_Value, round(avg(aq.PM10_Value)) as PM10_Value
from air_quality_Nov2017 as aq, air_stations_Nov2017 as ass
where aq.Station = ass.Station
group by ass.District_Name;
quit;


/*number discrepancies found with attempt to merge deaths and accident table due to misspelled observations in the DistrictName table

exploring columns to figure out and correct the errors */ 

/*unique districts in death column*/
proc sql;
select  District_Name, sum (Number) as Deaths
from deaths
group by District_Name
;
quit;

/*how many deaths in total*/

proc sql;
select  sum (Number) as Deaths
from deaths
;
quit;

proc sql;
select distinct DistrictName, sum (victims) as victims
from WORK.accidents_2017 as a
group by DistrictName
;
quit;


/*renaming mispelled rows in accidents_2017 to enable merge with deaths table*/
/*don't run if run already*/
/*PLease Note that you have to increase the length of the datatype for this to work*/
data accidents_2017;
   modify accidents_2017;
   if DistrictName = "Gràcia" then DistrictName="Gracia";
run;
/*or*/
proc sql;
update accidents_2017
set DistrictName = 'Sarrià-Sant Ge'
where DistrictName = 'Sarrià-San';
quit;

proc sql;
update accidents_2017
set DistrictName = 'Horta-Guinardo'
where DistrictName = 'Horta-Guin';
quit;

proc sql;
update accidents_2017
set DistrictName = 'Sant Andreu'
where DistrictName = 'Sant Andre';
quit;

proc sql;
update accidents_2017
set DistrictName = 'Ciutat Vella'
where DistrictName = 'Ciutat Vel';
quit;

proc sql;
update accidents_2017
set DistrictName = 'Sant Marti'
where DistrictName = 'Sant Martí';
quit;

proc sql;
update accidents_2017
set DistrictName = 'Sants-Montjuic'
where DistrictName = 'Sants-Mont';
quit;

/*Now merging deaths and accidents table and confirming if correct order*/

proc sql;
select distinct DistrictName, District_Name, sum(Victims) as victims, deaths
from accidents_2017 as a
full outer join 
(
select distinct District_Name, sum (Number) as deaths
from deaths 
group by District_Name
) as b 
on DistrictName = b.District_Name

group by DistrictName
;
quit;

/*Now final merge deaths, accidents and air quality table, confirming*/

/****************************validate with previous air quality table********************************************/
/**************************************run with next query*******************************************************/
proc sql;
select ass.District_Name as District_Name, round(avg(aq.O3_Value)) as O3_Value, round(avg(aq.NO2_Value)) as NO2_Value, round(avg(aq.PM10_Value)) as PM10_Value
from air_quality_Nov2017 as aq, air_stations_Nov2017 as ass
where aq.Station = ass.Station
group by ass.District_Name;
quit;

/*final merge*/
proc sql;
select distinct a.DistrictName, b.District_Name, sum(Victims) as Victims, Deaths, O3_Value, NO2_Value, PM10_Value
from accidents_2017 as a

full outer join 
(
select distinct District_Name, sum (Number) as Deaths
from deaths 
group by District_Name
) as b 
on a.DistrictName = b.District_Name

full outer join 
(
select ass.District_Name as District_Name, round(avg(aq.O3_Value)) as O3_Value, round(avg(aq.NO2_Value)) as NO2_Value, round(avg(aq.PM10_Value)) as PM10_Value
from air_quality_Nov2017 as aq, air_stations_Nov2017 as ass
where aq.Station = ass.Station
group by ass.District_Name
) as c 

on b.District_Name = c.District_Name

group by a.DistrictName
;
quit;


/* merging per death year */

proc sql;
select Distinct f.Year, f.District_Name, sum(Victims) as Accident_victims, Total_deaths
from accidents_2017 as e 
right join
(
select Year, District_Name, sum(Number) as Total_deaths
from deaths
group by Year, District_Name
) as f 
on e.DistrictName = f.District_Name
group by f.Year, f.District_Name
;
quit;


/* merging per death year 
proc sql;
select d.Year, d.District_Name, Total_deaths, accident_victims
from 
(
select  d.Year, d.District_Name, sum(d.Number) as Total_deaths
from
deaths as d 
inner join accidents_2017 as a 
on d.District_Name = a.DistrictName
group by d.Year,d.District_Name), 

(
select  dd.Year,dd.District_Name, sum(aa.Victims) as Accident_victims  
from deaths as dd 
inner join accidents_2017 as aa 
on dd.District_Name = aa.DistrictName
group by dd.Year,dd.District_Name)
where d.Year = dd.Year and 
d.District_Name = dd.District_Name
group by dd.Year,dd.District_Name 
;
quit;*/

/* where is the district where most immigrants stay */
proc sql;
select distinct District_Name, count(Nationality) as total_immigrants_living
from immigrants_by_nationality
where Nationality <> 'Spain'
group by District_Name
having total_immigrants_living >= ALL (select count(Nationality) as total_immigrants_living
from immigrants_by_nationality
where Nationality <> 'Spain'
group by District_Name
)
;
quit;

/* taking all the males with age <30, what's the precentage of them that are unemployed */

proc sql; 
select (a.nbr_unemp_males_U_30_yrs/b.T_nbr_unemp) * 100 as percentage_unemp_males_U_30_yrs 
from
(select count(Gender) as nbr_unemp_males_U_30_yrs
from unemployment
where Gender = 'Male'
and Neighborhood_Code in
(
select Neighborhood_Code
from population
where Age in ('15-', '20-', '25-')
group by Neighborhood_Code
))as a, 

(select sum(Number) as T_nbr_unemp
from unemployment) as b
;
quit;


/* district name with the most immigrant to emmigrant ratio */

proc sql;
select District_Name, Immigrants / Emigrants as ratio
from immigrants_emigrants_by_age
where Immigrants / Emigrants >= ALL (select Immigrants / Emigrants
from immigrants_emigrants_by_age
)
;
quit;

/* what's the ratio of unemployed male to female in every neighbourhood */

proc sql;
select Neighborhood_Name, sum(a.Total_Males) / sum(b.Total_Females) as Gender_ratio 
from
(select p2.Neighborhood_Name as Neighborhood_Name, sum(p2.Number) as Total_Males
   from unemployment as p2
   where gender = 'Male'
   group by p2.Neighborhood_Name, Gender) as a, 
(select p1.Neighborhood_Name as p1Neighborhood_Name, sum(p1.Number) as Total_Females
   from unemployment as p1
   where gender = 'Fema'
   group by p1.Neighborhood_Name, Gender) as b
 group by Neighborhood_Name
;
quit;

/* what's the ratio of unemployed male to female in every district */
proc sql;
select District_Name, sum(a.Total_Males) / sum(b.Total_Females) as Gender_ratio 
from
(select p2.District_Name as District_Name, sum(p2.Number) as Total_Males
   from unemployment as p2
   where gender = 'Male'
   group by p2.District_Name, Gender) as a, 
(select p1.District_Name as p1District_Name, sum(p1.Number) as Total_Females
   from unemployment as p1
   where gender = 'Fema'
   group by p1.District_Name, Gender) as b
 group by District_Name
;
quit;

/*compare the births, deaths, immigrants and emmigrants number, how does this affect population*/
proc sql;

select b.Year, b.District_Name, sum (distinct b.Number) as Number_births, sum (distinct d.Number) as Number_deaths, 
sum (distinct e.Immigrants) as Number_Innigrants, sum (distinct e.Emigrants) as Number_emigrants
from births as b 
full outer join deaths as d on b.District_Name = d.District_Name
full outer join immigrants_emigrants_by_sex as e on b.District_Name = e.District_Name
group by b.Year, b.District_Name
order by b.Year;
;
quit;


/*where do immigrants come from ?*/
proc sql;
select Nationality, sum (Number) as Number
From immigrants_by_nationality
group by Nationality
;
quit;

/* whats the total unemployment across the years */
proc sql;
select Year, sum(Number) as rate
from unemployment
	group by Year
;
quit;

PROC SQL;
select Station, round(avg(O3_Value)) as O3_Value, round(avg(NO2_Value)) as NO2_Value, round(avg(PM10_Value)) as PM10_Value
from air_quality_Nov2017
group by Station
;
QUIT;


/* geographical map table for air quality data
PROC SQL;
select Longitude, Latitude, O3_Value, NO2_Value, PM10_Value
from air_quality_Nov2017
;
QUIT;*/



/*	Plot the accidents to identify dangerous regions(neighborhood) in the city*/
PROC SQL;
select NeighborhoodName, sum(Victims) as Victims, sum(Mild_injuries) as Mild_injuries, sum(Serious_injuries) as Serious_injuries, sum(Vehicles_involved) as Vehicles_involved
from accidents_2017 as ac
group by NeighborhoodName
;
QUIT;

/*	Plot the accidents to identify dangerous regions(district) in the city*/
PROC SQL;
select DistrictName, sum(Victims) as Victims, sum(Mild_injuries) as Mild_injuries, sum(Serious_injuries) as Serious_injuries, sum(Vehicles_involved) as Vehicles_involved
from accidents_2017 as ac
group by DistrictName
;
QUIT;

/* geographical map table 
PROC SQL;
select Victims, Vehicles_involved, Longitude, latitude
from accidents_2017 as ac
;
QUIT;*/


PROC SQL; /*Tableau Tables*/
Create Table DB as

	Select *
	FROM NYC.FLIGHTS f full join NYC.AIRPORTS a on f.dest= a.faa
		full join NYC.weather w on f.time_hour=w.time_hour
		full join NYC.airlines ai on ai.carrier=f.carrier
		full join NYC.planes p on f.tailnum = p.tailnum
;
Quit;







