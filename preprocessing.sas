/* import datasets */

%let biagio_path_pc = "C:\Users\biagi\Desktop\university\Second Year\First Semester\questionnaire\project\Analysis_Wine_Questionnaire\WINE_SURVEY_RESPONSES_18012022.xlsx";
%let biagio_path_web = "/home/u45129182/new/WINE_SURVEY_RESPONSES_18012022.xlsx";
%let gianluigi_path = "C:\Users\utente\Desktop\Analysis of Questionnaire Data\WINE_SURVEY_RESPONSES_18012022.xlsx";
%let anna_path="C:\Users\Annabelle\Desktop\Analysis_Wine_Questionnaire\WINE_SURVEY_RESPONSES_18012022.xlsx";
%let thamires_path="C:\Users\Thamires\Desktop\ADQ\WINE_SURVEY_RESPONSES_18012022.xlsx";

/*please put here your local path and use current_path in the three import below, so that we just need to change it once and not three times*/
%let current_path = &anna_path;

PROC IMPORT OUT=Wine_IT
	DATAFILE=&current_path
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="IT";
RUN;
PROC IMPORT OUT=Wine_EN
	DATAFILE=&current_path
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="EN";
RUN;
PROC IMPORT OUT=Naming_Convention
	DATAFILE=&current_path
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="NAMING CONVENTION";
RUN;

/*resize datasets*/

DATA WINE_IT_sub;
set WINE_IT;
if _N_ <= 196 then output;
run; 

DATA WINE_EN_sub;
set Wine_EN;
if _N_ <= 51 then output;
run;

/*TRANSLATE ITALIAN DATASET TO ENGLISH*/

/*load the naming convention in a list*/
proc sql noprint;
select 'Naming_convention'n into :collist separated by ' ' 
from Naming_Convention nc;
quit;
/*length of the list, how many variables*/
%let len = %sysfunc(countw(&collist));

/*in order to do not modify the original dataset, at the end we will remove this step*/
data tmp_Wine_IT;
	set Wine_IT_sub;
run;

/*EXTRACT CHARVARIABLES*/
proc sql;
     select name into :vname separated by ' '
     from dictionary.columns
     where MEMNAME='WINE_IT'  AND type='char';
quit;

/*TRANSLATE*/
DATA TRANSLATED_WINE_IT_SUB;
LENGTH &VNAME $200;
FORMAT &VNAME $CHAR200.;
INFORMAT &VNAME $CHAR200.;
SET TMP_WINE_IT;
	array vars [*] _character_;
	DO I = 1 TO DIM(VARS);
		IF VARS[I] = "Mai assaggiato" THEN VARS[I] = "Never tasted";
		ELSE IF VARS[I] = "Si" THEN VARS[I] = "Yes";
		ELSE IF VARS[I] = "Nessuna" THEN VARS[I] = "None";
		ELSE IF VARS[I] = "Di base (conoscenza amatoriale)" THEN VARS[I] = "Basic (amateur knowledge level)";
		ELSE IF VARS[I] = "Media (conoscenza semi-professionale)" THEN VARS[I] = "Medium (semi-professional knowledge level)";
		ELSE IF VARS[I] = "Avanzata (conoscenza professionale)" THEN VARS[I] = "High (professional knowledge level)";
		ELSE IF VARS[I] = "Mai" THEN VARS[I] = "Never";
		ELSE IF VARS[I] = "1-2 volte al mese" THEN VARS[I] = "1-2 times per month";
		ELSE IF VARS[I] = "3-4 volte al mese" THEN VARS[I] = "3-4 times per month";
		ELSE IF VARS[I] = "5-6 volte al mese" THEN VARS[I] = "5-6 times per month";
		ELSE IF VARS[I] = "7+ volte al mese" THEN VARS[I] = "7+ times per month";
		ELSE IF VARS[I] = "Meno di una bottiglia" THEN VARS[I] = "Less than 1 bottle";
		ELSE IF VARS[I] = "1-3 bottiglie" THEN VARS[I] = "1-3 bottles";
		ELSE IF VARS[I] = "4-6 bottiglie" THEN VARS[I] = "4-6 bottles";
		ELSE IF VARS[I] = "7-9 bottiglie" THEN VARS[I] = "7-9 bottles";
		ELSE IF VARS[I] = "10-12 bottiglie" THEN VARS[I] = "10-12 bottles";
		ELSE IF VARS[I] = "12+ bottiglie" THEN VARS[I] = "12+ bottles";
		ELSE IF VARS[I] = "Meno di 5€" THEN VARS[I] = "Less than 5€";
		ELSE IF VARS[I] = "5€ - medo di 15€" THEN VARS[I] = "5€ to less than 15€";
		ELSE IF VARS[I] = "15€ - meno di 30€" THEN VARS[I] = "15€ to less than 30€";
		ELSE IF VARS[I] = "30€ - meno di 45€" THEN VARS[I] = "30€ to less than 45€";
		ELSE IF VARS[I] = "45€ - meno di 60€" THEN VARS[I] = "45€ to less than 50€";
		ELSE IF VARS[I] = "60€ o più" THEN VARS[I] = "60€ and more";
		ELSE IF VARS[I] = "Non lo so" THEN VARS[I] = "I don't know";
		ELSE IF VARS[I] = "Donna" THEN VARS[I] = "Female";
		ELSE IF VARS[I] = "Uomo" THEN VARS[I] = "Male";
		ELSE IF VARS[I] = "Preferisco non rispondere" THEN VARS[I] = "Prefer not to say";
		ELSE IF VARS[I] = "Scuola elementare o media inferiore" THEN VARS[I] = "Primary and medium school";
		ELSE IF VARS[I] = "Scuola media superiore (liceo o istituto tecnico)" THEN VARS[I] = "High school";
		ELSE IF VARS[I] = "Titolo universitario" THEN VARS[I] = "University degree";
		ELSE IF VARS[I] = "Sicilia" THEN VARS[I] = "Sicily";
		ELSE IF VARS[I] = "Altra regione in Italia (no Sicilia)" THEN VARS[I] = "Other region in Italy (no Sicily)";
		ELSE IF VARS[I] = "Paese EU (no Italia)" THEN VARS[I] = "Foreign EU country (no Italy)";
		ELSE IF VARS[I] = "Paese extra EU" THEN VARS[I] = "Foreign not EU country (no Italy)";
		ELSE IF VARS[I] = "Studente" THEN VARS[I] = "Student";
		ELSE IF VARS[I] = "Impiegato" THEN VARS[I] = "Employee";
		ELSE IF VARS[I] = "Libero professionista" THEN VARS[I] = "Freelancer";
		ELSE IF VARS[I] = "Disoccupato" THEN VARS[I] = "Unemployed";
		ELSE IF VARS[I] = "Pensionato" THEN VARS[I] = "Retired";
		ELSE IF VARS[I] = "Casalinga/o" THEN VARS[I] = "Housewife/Housemen";
	END;
	DROP I;
RUN;

/*now we convert variables from character to numeric the english version*/

Data COL_CONVERTED_EN (drop = WHITE_WINE RED_WINE ROSE_WINE SPARKLING_WINE  );
Set WINE_EN_sub;
Array old_var(4) $ WHITE_WINE RED_WINE ROSE_WINE SPARKLING_WINE ;
Array new_var(4) var1-var4;
Do i = 1 to 4;
		new_var(i) = input(old_var(i), best.); 
		/*if new_var(i)=. then new_var(i)=0;*/
label var1= 'WHITE_WINE'
var2= 'RED_WINE'
var3= 'SWEET_WINE'
var4= 'SPARKLING_WINE';

rename var1= WHITE_WINE
var2= RED_WINE
var3= ROSE_WINE
var4= SPARKLING_WINE;


END;
OPTIONS MISSING = 0;
run;


/*now we convert variables from character to numeric the italian version*/
Data COL_CONVERTED_IT (drop = WHITE_WINE  ROSE_WINE RED_WINE SPARKLING_WINE SWEET_WINE );
Set TRANSLATED_WINE_IT_sub;
Array old_var(5) $ WHITE_WINE ROSE_WINE RED_WINE SPARKLING_WINE SWEET_WINE ;
Array new_var(5) var1-var5;
Do i = 1 to 5;
		new_var(i) = input(old_var(i), best.); 
		/*if new_var(i)=. then new_var(i)=0;*/
label var1= 'WHITE_WINE'
var2= 'ROSE_WINE'
var3= 'RED_WINE'
var4= 'SPARKLING_WINE'
var5= 'SWEET_WINE';

rename var1= WHITE_WINE
var2= ROSE_WINE
var3= RED_WINE
var4= SPARKLING_WINE
var5= SWEET_WINE;


END;

run;
/*NOW WE CAN APPEND THE 2 DATASETS */
/*set all char variables to same length (don't doing this may cause truncation in the values)*/
proc sql noprint;
     select name into :vname separated by ' '
     from dictionary.columns
     where MEMNAME='COL_CONVERTED_EN'  AND type='char';
quit;
data COL_MODIFIED_EN;
     length &vname $ 1000; /*even though this is a waste of space, with less than 300 rows this is not a big deal*/
     set COL_CONVERTED_EN;
run;
DATA COL_MODIFIED_IT;
	LENGTH &VNAME $ 1000;
	SET COL_CONVERTED_IT;
RUN;

data APPENDED_DATASET;  
set COL_MODIFIED_IT COL_MODIFIED_EN;
run;
data NAMING_CONVENTION (drop = i reasonn1-reasonn4 reasonal1-reasonal4 reasona1-reasona4);
set APPENDED_DATASET;
	array choices[4] $ 6 reasonn1-reasonn4 ("home" "gift" "party" "taste" );
	array choices_italian[4] $ 32 reasonal1-reasonal4 ("Consumo casalingo"
												   "Per un regalo"
												   "Per un evento speciale/una festa"
												   "Per provare un nuovo vino");

	array choices_english[4] $ 25 reasona1-reasona4 ("Home consumption" 
													 "To buy a gift"
												   	 "For a special event/party"
												   	 "To try a new wine");
	do i = 1 to 4;
		BUYING_REASON = tranwrd(BUYING_REASON, strip(choices_english[i]), strip(choices[i]));
		BUYING_REASON = tranwrd(BUYING_REASON, strip(choices_italian[i]), strip(choices[i]));
	end;
run;
/*split the reasons in the dummy variables*/
data DUMMIFIED_WINE_EN (DROP = j choice1-choice4);
	set NAMING_CONVENTION;
	array choices[4] home gift party taste;
	array choices_str[4] $ 6 choice1-choice4 ("home" "gift" "party" "taste");	
	do j = 1 to 4;
		if find(buying_reason, strip(choices_str[j])) > 0 then choices[j] = 1;
		else choices[j] = 0;
	end;
run;
/*proc print data=finalversion; run;*/
data reordered_final_version;
retain WINE_PREFERENCE BEER_PREFERENCE SOFT_PREFERENCE COCKTAIL_PREFERENCE WHITE_WINE ROSE_WINE RED_WINE SPARKLING_WINE SWEET_WINE WINE_TASTING WINERY_VISIT
WINE_COURSE WINE_KNOWLEDGE BUYING_EXPERIENCE WINE_BOTTLES SUPERMARKET WINE_SHOP ONLINE_SHOP GRAPE_ORIGIN GRAPE_VARIETY
BUDGET_FRIENDLY BRAND_AWARNESS VINTAGE LABEL_INFO PACKAGING PROMOTION BOTTLE_BUDGET BUYING_FREQUENCY 
/*BUYING_REASON*/ PARTY GIFT HOME TASTE
ETNA_DOC ETNA_BUYING ETNA_PREFERENCE ETNA_FLAVOR SICILIAN_EXCELLENCES ETNA_EXPENSIVE ETNA_QUALITY ETNA_RECOMMENDATION 
GENDER AGE EDUCATION LOCATION JOB;
set DUMMIFIED_WINE_EN;
run;
proc print data= reordered_final_version;run;
/*tranform categorical variable in numerical */
Data new_reordered_final_version (drop = WINE_TASTING WINERY_VISIT WINE_COURSE ETNA_DOC ETNA_BUYING WINE_KNOWLEDGE BOTTLE_BUDGET
									BUYING_EXPERIENCE WINE_BOTTLES);
Set reordered_final_version;
Array old_var(9) $ WINE_TASTING WINERY_VISIT WINE_COURSE ETNA_DOC ETNA_BUYING WINE_KNOWLEDGE BOTTLE_BUDGET BUYING_EXPERIENCE WINE_BOTTLES ;
Array new_var(9) var1-var9;
Do i = 1 to 4;
	if old_var(i) = 'No' then new_var(i) = 0; else new_var(i) = 1;
End;
/*Do i= 5 to 6;
if old_var(i) = 'Yes' then new_var(i) = 1; else if old_var(i) = 'No' then new_var(i) = -1; else if old_var(i)= 'Si' then new_var(i)= 1;else new_var(i)= 0;
end;*/
if ETNA_BUYING = 'Yes' then var5 = 1; else if ETNA_BUYING = 'No' then var5 = -1;/*else if ETNA_BUYING='Si' then var5=1; */else var5 = 0;
if WINE_KNOWLEDGE = "None" then var6 = 1;else if WINE_KNOWLEDGE = "Basic" then var6 = 2; else if WINE_KNOWLEDGE = "Medium" then var6 = 3;
		else if WINE_KNOWLEDGE= "Basic (amateur knowledge level)" then var6= 2; 
		else if WINE_KNOWLEDGE = "Medium (semi-professional knowledge level)" then var6=3; 
		/*else if WINE_KNOWLEDGE= 'Nessuna' then var6= 1; else if WINE_KNOWLEDGE= "Di base (conoscenza amatoriale)" then var6= 2;  
		else if WINE_KNOWLEDGE= "Di base (conoscenza amatoriale)" then var6= 2; 
		else if WINE_KNOWLEDGE= "Media (conoscenza semi-professionale)" then var6= 3; */
		else var6=4;
if BOTTLE_BUDGET = 'Less than 5€' then var7 = 1; 
else if BOTTLE_BUDGET = '5€ to less than 15€' then var7= 2; 
else if BOTTLE_BUDGET= '15€ to less than 30€' then var7=3; 
else if BOTTLE_BUDGET= '30€ to less than 45€' then var7=4; 
else if BOTTLE_BUDGET= '45€ to less than 60€' then var7=5; 
else if BOTTLE_BUDGET= '60€ and more' then var7=6;  
else var7= '';
		
if BUYING_EXPERIENCE = 'Never' then var8 = 1; else if BUYING_EXPERIENCE = '1-2 times per month' then var8= 2; 
		else if BUYING_EXPERIENCE = '3-4 times per month' then var8= 3; else if BUYING_EXPERIENCE = '5-6 times per month' then var8= 4;
		else if BUYING_EXPERIENCE = '7+ times per month' then var8= 5; else var8= '';

if WINE_BOTTLES = 'Less than 1 bottle' then var9= 1; else if WINE_BOTTLES= '1-3 bottles' then var9=2; else if WINE_BOTTLES= '4-6 bottles' then var9=3;
				else if WINE_BOTTLES= '7-9 bottles' then var9=4; else if WINE_BOTTLES= '10-12 bottles' then var9=5;
				else if WINE_BOTTLES= '12+ bottles' then var9=6; else var9='';

label var1 = 'WINE_TASTING'
var2 = 'WINERY_VISIT'
var3 = 'WINE_COURSE'
var4 = 'ETNA_DOC'
var5 = 'ETNA_BUYING'
var6 = 'WINE_KNOWLEDGE'
var7 = 'BOTTLE_BUDGET'
var8 = 'BUYING_EXPERIENCE'
var9 = 'WINE_BOTTLES';
rename var1 = WINE_TASTING
var2 = WINERY_VISIT
var3 = WINE_COURSE
var4 = ETNA_DOC
var5 = ETNA_BUYING
var6 = WINE_KNOWLEDGE
var7 = BOTTLE_BUDGET
var8 = BUYING_EXPERIENCE
var9 = WINE_BOTTLES;

run;
proc print data= new_reordered_final_version;run;

/*REORDERING COLUMNS*/

data finaldata (drop = i);
retain DATE VERSION WINE_PREFERENCE BEER_PREFERENCE SOFT_PREFERENCE COCKTAIL_PREFERENCE WHITE_WINE ROSE_WINE RED_WINE SPARKLING_WINE SWEET_WINE WINE_TASTING WINERY_VISIT
WINE_COURSE WINE_KNOWLEDGE BUYING_EXPERIENCE WINE_BOTTLES SUPERMARKET WINE_SHOP ONLINE_SHOP GRAPE_ORIGIN GRAPE_VARIETY
BUDGET_FRIENDLY BRAND_AWARNESS VINTAGE LABEL_INFO PACKAGING PROMOTION BOTTLE_BUDGET BUYING_FREQUENCY 
/*BUYING_REASON*/ PARTY GIFT HOME TASTE
ETNA_DOC ETNA_BUYING ETNA_PREFERENCE ETNA_FLAVOR SICILIAN_EXCELLENCES ETNA_EXPENSIVE ETNA_QUALITY ETNA_RECOMMENDATION 
GENDER AGE EDUCATION LOCATION JOB;
set new_reordered_final_version;
run;

/*HANDELING MISSING VALUE*/
/*Imputing Categorical values with mode */
proc freq data=finaldata order=freq noprint;
	TABLES  buying_reason/NOPERCENT NOCUM out=buying_reason_freq ; 
run;
proc sql noprint; 
	select buying_reason into :mode_reason from buying_reason_freq(obs=1) where buying_reason is not null;
quit;
data wine_categorical;
	set finaldata;
	if missing(buying_reason) then buying_reason = "&mode_reason";  
run;
/*Imputing Numeric values with mean value*/
proc stdize data=wine_categorical out=wine_numeric  
   REPONLY
   method= MEDIAN;
   var  WHITE_WINE--ETNA_RECOMMENDATION; 
run;
proc print data= wine_numeric; run;
/* Round Imputed Values*/
data wine_imputed;
	set wine_numeric;
	array _nums {*} _numeric_;
	do i = 1 to dim(_nums);
  		_nums{i} = round(_nums{i});
	end;
	drop i;
run;

/*CONVERT THE AGE VARIABLE INTO A CATEGORICAL VARIABLE WITH 5 CLASSES*/

DATA data_Age_Cat;
SET wine_imputed;
IF age >= 0 AND age <= 17 THEN
	Age_Class = "minor";
ELSE IF age >= 18 AND age <= 24 THEN
	Age_Class ="18-25";
ELSE IF age >= 25 AND age <= 30 THEN
	Age_Class = "24-30";
ELSE IF age >= 31 AND age <= 50 THEN
	Age_Class = "31-50";
ELSE 
	Age_Class = ">50";
RUN;

/*remove minors if any*/

DATA No_Minors;
SET data_Age_Cat;
IF Age_Class = "minor" THEN
	DELETE;
RUN;

/*CONVERT DateTime FROM CHAR TO DateTime*/
DATA finaldataset;
SET No_Minors;
	DateTime =input(Date,anydtdtm.);
	format DateTime datetime20.;
RUN;

DATA dataset_drop (DROP = AS AT AU AV AW AX DATE); 
SET finaldataset;
RUN;
proc print data= dataset_drop; run;
DATA dataset ;
retain DateTime;
set dataset_drop;
run;

PROC print data= dataset; run;


/*PREPROCESSING FOR ANALYSIS OF CORRESPONDENCE*/


/*transforming the variable ETNA_PREFERENCE into categorical*/

DATA data_correspondence;
SET dataset;
IF ETNA_PREFERENCE = 1 THEN
	etnapreference = "Very_Low ";
ELSE IF ETNA_PREFERENCE = 2 THEN
	etnapreference ="Low";
ELSE IF ETNA_PREFERENCE = 3  THEN
	etnapreference = "High";
ELSE
	etnapreference = "Very_High";

IF WINE_KNOWLEDGE = 1 THEN 
	wineknowledge = "None   ";
ELSE IF WINE_KNOWLEDGE = 2 THEN
	wineknowledge = "Basic";
ELSE IF WINE_KNOWLEDGE = 3 THEN
	wineknowledge = "Medium";
ELSE 
	wineknowledge = "High";
	RUN;
	
	 

