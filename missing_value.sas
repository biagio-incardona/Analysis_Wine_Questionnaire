/*HANDELING MISSING VALUE*/
/*Imputing Categorical values with mode */
proc freq data=reordered_final_version order=ferq noprint;
	TABLES  WINE_BOTTLES bottle_budget etna_buying buying_reason/NOPERCENT NOCUM 
		out=WINE_BOTTLES_freq bottle_budget_freq etna_buying_freq buying_reason_freq; 
run;
proc sql noprint; 
	select WINE_BOTTLES into :mode_bottles from WINE_BOTTLES_freq(obs=1) where WINE_BOTTLES is not null;
	select bottle_budget into :mode_budget from bottle_budget_freq(obs=1) where bottle_budget is not null;
	select etna_buying into :mode_buying from etna_buying_freq(obs=1) where etna_buying is not null;
	select buying_reason into :mode_reason from buying_reason_freq(obs=1) where buying_reason is not null;
quit;
%PUT &mtitle;
data wine_categorical;
	set reordered_final_version;
	if missing(WINE_BOTTLES) then WINE_BOTTLES = "1-3 bottles";
	if missing(bottle_budget) then bottle_budget = "5€ to less than 15€"; 
	if missing(etna_buying) then etna_buying = "Yes"; 
	if missing(buying_reason) then buying_reason = "home";  
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
