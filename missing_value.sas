/*HANDELING MISSING VALUE*/
/*Imputing Categorical values with mode */
proc freq data=finaldata order=ferq noprint;
	TABLES  WINE_BOTTLES/NOPERCENT NOCUM out=WINE_BOTTLES_freq ; 
	TABLES  bottle_budget/NOPERCENT NOCUM out=bottle_budget ; 
	TABLES  etna_buying/NOPERCENT NOCUM out=etna_buying ; 
	TABLES  buying_reason/NOPERCENT NOCUM out=buying_reason ; 
run;
proc sql noprint; 
	select WINE_BOTTLES into :mode_bottles from WINE_BOTTLES_freq(obs=1) where WINE_BOTTLES is not null;
	select bottle_budget into :mode_budget from bottle_budget_freq(obs=1) where bottle_budget is not null;
	select etna_buying into :mode_buying from etna_buying_freq(obs=1) where etna_buying is not null;
	select buying_reason into :mode_reason from buying_reason_freq(obs=1) where buying_reason is not null;
quit;
data wine_categorical;
	set finaldata;
	if missing(WINE_BOTTLES) then WINE_BOTTLES = "&mode_bottles";
	if missing(bottle_budget) then bottle_budget = "&mode_budget"; 
	if missing(etna_buying) then etna_buying = "&mode_buying"; 
	if missing(buying_reason) then buying_reason = "&mode_reason";  
run;
/*Imputing Numeric values with mean value*/
proc stdize data=wine_categorical out=wine_numeric  
   REPONLY
   method= MEDIAN;          /* or MEDIAN*/
   var  WINE_PREFERENCE--SWEET_WINE  
		SUPERMARKET--PROMOTION  
		BUYING_FREQUENCY 
		ETNA_PREFERENCE--ETNA_RECOMMENDATION ; 
run;
/* Round Imputed Values*/
data wine_imputed;
	set wine_numeric;
	array _nums {*} _numeric_;
	do i = 1 to dim(_nums);
  		_nums{i} = round(_nums{i});
	end;
	drop i;
run;
proc print data=wine_imputed;

run;
