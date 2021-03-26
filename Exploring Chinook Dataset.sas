libname chinook "C:\Users\mobama\OneDrive - IESEG\Business reporting tools\SQL\Chinook dataset-20200922";

/*Financial*/
/***** What about company sales (and the evolution over the years, or eg per
month)? Make sure to accurately sort your results******/

proc sql;
	select year(datepart(InvoiceDate)) as Year,
	case month(datepart(InvoiceDate)) 
		WHEN 1 THEN 'January'
         WHEN 2 THEN 'February'
         WHEN 3 THEN 'March'
         WHEN 4 THEN 'April'
         WHEN 5 THEN 'May'
         WHEN 6 THEN 'June'
         WHEN 7 THEN 'July'
         WHEN 8 THEN 'August'
         WHEN 9 THEN 'September'
         WHEN 10 THEN 'October'
         WHEN 11 THEN 'November'
         ELSE 'December'
END as Month,
sum(Total) as Sales
	from chinook.Invoices
	group by 1,2
	order by 1 desc, 2 asc;
quit;

/*****How many purchases are made per invoice?*****/

proc sql;
select InvoiceId, count(Quantity) as Purchases
from chinook.invoice_items
group by 1
order by 1, 2 asc;
quit;

/*****Customers*****/

/****How many customers do we have? Are they company clients or not? ******/

proc sql;
	select 
		case when company = 'NA' then 'No Company'
		else company end as Companies, 
		count(customerid) as Nb_of_Customers
	from chinook.customers
	group by 1
	order by 2 desc;
quit;

/****How long has it been since the last purchase (recency)? How many purchases
has the customer done (frequency)? How much does the customer spend on
average (monetary value)?******/

proc sql outobs=1;
	select CustomerID, Nb_of_years, avg_expenses, Purchases_freq
	from (select CustomerID,
				yrdif(datepart(InvoiceDate), today()) as Nb_of_years,
				 avg(Total) as avg_expenses,
				count(Total) / sum(Total) * 100 as Purchases_freq_(%)		
		from chinook.invoices)
		group by 1
		order by 2 asc;
quit;

/****How long has it been since the last purchase (recency)? How many purchases
has the customer done (frequency)? How much does the customer spend on
average (monetary value)? With the name of the customer******/

proc sql outobs=1;
	select inv.CustomerID, custom.FirstName, custom.LastName, inv.Nb_of_years, inv.avg_expenses, inv.Purchases_freq
	from (select i.CustomerID,
				yrdif(datepart(i.InvoiceDate), today()) as Nb_of_years,
				 avg(i.Total) as avg_expenses,
				count(i.Total) / sum(i.Total) as Purchases_freq		
		from chinook.invoices as i
		group by 1, 2) as inv
		inner join chinook.customers AS custom
		on inv.CustomerID = custom.CustomerID
		order by 4 asc;
quit;

/******Give insight into the tenure of customers (how long are they already with the
company)******/

proc sql;
	select CustomerId, min(year(datepart(InvoiceDate))) as First_purchase,
			yrdif(datepart(min(InvoiceDate)), today()) as yr_of_retention
		from chinook.invoices
	group by 1
	order by 1;
quit; 

/*****Where are our customers located and what is our biggest market (sales per
market)? Note that a market may also be US/Europe/Asia. ******/

proc sql;	
	select distinct C1.CustomerId, C1.Market, C1.Country, C1.City, sum(I.Total) as Sales
	from (select C.CustomerId, C.City, C.Country,
		case C.country
			when 'USA' then 'US'
			when 'Australia' then 'Oceania'
			when 'Canada' then 'America'
			when 'Chile' then 'America'
			when 'India' then 'Asia'
			else 'Europe' end as Market
	from chinook.customers as C) as C1
	inner join chinook.invoices as I
	on C1.CustomerId = I.CustomerId 
	where C1.Market IN ('Asia','Europe','US')
	group by 1,2,3,4
	order by 5 desc;
quit;

/****Internal business processes*****/

/******Give insight into the genres, tracks and media types that are bought
most/least. What are the conclusions? You can also create groups of low,
average and good performing groups. *********/

/****From the lowest performing group to the highest*/
proc sql;
	select IV2.CustomerId, G.GenreId, G.Name, 
			MT.MediaTypeId, MT.Name, 
			T.TrackID, T.Name, IV2.Sales, IV2.avg_Sales
	from (select IV.CustomerId, sum(IV.Total) as Sales, avg(IV.Total) as avg_Sales
			from chinook.invoices as IV
			group by 1) as IV2
	inner join chinook.genres as G
	on IV2.CustomerId = G.GenreId
		inner join chinook.media_types as MT
		on IV2.CustomerId = MT.MediaTypeId
			inner join chinook.tracks as T
			on IV2.CustomerId = T.TrackId 
	group by 2,4,6
	order by 8 asc;
quit;

/**From the highest performing group to the lowest**/

proc sql;
	select IV2.CustomerId, G.GenreId, G.Name, 
			MT.MediaTypeId, MT.Name, 
			T.TrackID, T.Name, IV2.Sales, IV2.avg_Sales
	from (select IV.CustomerId, sum(IV.Total) as Sales, avg(IV.Total) as avg_Sales
			from chinook.invoices as IV
			group by 1) as IV2
	inner join chinook.genres as G
	on IV2.CustomerId = G.GenreId
		inner join chinook.media_types as MT
		on IV2.CustomerId = MT.MediaTypeId
			inner join chinook.tracks as T
			on IV2.CustomerId = T.TrackId 
	order by 8 desc;
quit;

/***Can we delete tracks that do not sell well?*/ 

/*Are there tracks that have no
sales?*/

/*Are there any characteristics related to these tracks? How many bytes
do we save by deleting them?*/

proc sql; 
	select IIT.TrackId, T.Milliseconds, T.Bytes, IIT.Quantity
	from chinook.tracks as T
	inner join chinook.invoice_items as IIT
	on T.TrackId = IIT.InvoiceLineId 
	group by 1
	order by 4 asc;
quit;

/*How many employees do we have, how many are about to retire (age > 60),
how long are they in the company? */

/**Employees'ID, First name, Last name, Age and years in the company*/

proc sql;
	select EmployeeID, FirstName, LastName, 
			yrdif(datepart(BirthDate), Today()) as Age, 
			yrdif(datepart(HireDate), Today()) as Corporate_years
	from chinook.employees
	order by 4 desc;
quit;

/*How many employees are more than 60 years old. They can be considered as retirees if the retire age is 60 years*/
proc sql;
 
	select count(*)
	from chinook.employees
	where yrdif(datepart(BirthDate), Today()) in (select yrdif(datepart(BirthDate), Today())
					from chinook.employees
					where yrdif(datepart(BirthDate), Today()) > 60);
quit;

/*Which employees will be a retiree in 2 years*/

proc sql;
 
	select FirstName, LastName, yrdif(datepart(BirthDate), Today()) as Age
	from chinook.employees
	where yrdif(datepart(BirthDate), Today()) in (select yrdif(datepart(BirthDate), Today())
					from chinook.employees
					where yrdif(datepart(BirthDate), Today()) <= 60
					and yrdif(datepart(BirthDate), Today()) >= 58);
quit;

/*How many different roles do we have?*/
proc sql;
	select count(distinct Title)
	from chinook.employees;
quit;

/*What different roles do we have?*/
	 
proc sql;
	select distinct Title
	from chinook.employees;
quit;

/*How many sales does each of the salespeople have? How many sales does
each of the supervisors have? What areas do they serve?*/ 

proc sql;
	select e.EmployeeId, e.Title, i.BillingCountry, i.BillingCity, count(i.Total) as Sales_Nbr
	from chinook.employees as e
	inner join chinook.invoices as i
	on e.Employeeid = i.Invoiceid
	group by 2
	except
		select e.EmployeeId, e.Title, i.BillingCountry, i.BillingCity, count(i.Total) as Sales_Nbr
		from chinook.employees e, chinook.invoices i
		where e.Employeeid = i.Invoiceid
		and  e.Title in(select e.Title from Chinook.employees as  e where e.title contains ('Staff'))
		group by 2
		having count(i.Invoiceid)
		order by 5 asc;
quit;