/* import datasets */
/*BIAGIO FILE PATH, DON'T REMOVE PLEASE:
C:\Users\biagi\Desktop\university\Second Year\First Semester\questionnaire\project\Analysis_Wine_Questionnaire\WINE_SURVEY_RESPONSES.xlsx*/
PROC IMPORT OUT=Wine_IT
	DATAFILE=""
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="IT";
RUN;

PROC IMPORT OUT=Wine_EN
	DATAFILE=""
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="EN";
RUN;

PROC IMPORT OUT=Naming_Convention
	DATAFILE=""
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="NAMING CONVENTION";
RUN;


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
	set Wine_IT;
run;

/*defined a sort of dictionary to translate, it is the fastest structure i was able to find*/
proc format;
value $translate
	"Mai assaggiato" = "Never tasted"
 	"Si"  = "Yes"
 	"Nessuna"  = "None"
	 "Di base (conoscenza amatoriale)"  = "Basic (amateur knowledge level)"
	 "Media (conoscenza semi-professionale)"  = "Medium (semi-professional knowledge level)"
	 "Avanzata (conoscenza professionale)"  = "High (professional knowledge level)"
	 "Mai"  = "Never"
	 "1-2 volte al mese"  = "1-2 times per month"
	 "3-4 volte al mese"  = "3-4 times per month"
	 "5-6 volte al mese"  = "5-6 times per month"
	 "7+ volte al mese"  = "7+ times per month"
	 "Meno di una bottiglia"  = "Less than 1 bottle"
	 "1-3 bottiglie"  = "1-3 bottles"
	 "4-6 bottiglie"  = "4-6 bottles"
	 "7-9 bottiglie"  = "7-9 bottles"
	 "10-12 bottiglie"  = "10-12 bottles"
	 "12+ bottiglie"  = "12+ bottles"
	 "Meno di 5€"  = "Less than 5€"
	 "5€ - medo di 15€"  = "5€ to less than 15€"
	 "15€ - meno di 30€"  = "15€ to less than 30€"
	 "30€ - meno di 45€"  = "30€ to less than 45€"
	 "45€ - meno di 60€"  = "45€ to less than 50€"
	 "60€ o più"  = "60€ and more "
	 "Non lo so"  = "I don't know "
	 "Donna"  = "Female "
	 "Uomo"  = "Male "
	 "Preferisco non rispondere"  = "Prefer not to say "
	 "Scuola elementare o media inferiore"  = "Primary and medium school "
	 "Scuola media superiore (liceo o istituto tecnico)"  = "High school "
	 "Titolo universitario"  = "University degree "
	 "Sicilia"  = "Sicily "
	 "Altra regione in Italia (no Sicilia)"  = "Other region in Italy (no Sicily) "
	 "Paese EU (no Italia)"  = "Foreign EU country (no Italy) "
	 "Paese extra EU"  = "Foreign not EU country (no Italy) "
	 "Studente"  = "Student "
	 "Impiegato"  = "Employee "
	 "Libero professionista"  = "Freelancer "
	 "Disoccupato"  = "Unemployed "
	 "Pensionato"  = "Retired "
	 "Casalinga/o"  = "Housewife/Housemen ";
run;


/*macro to translate the italian responses*/
%macro translate;
    %do i = 1 %to &len;
        %let j = %scan(&collist,&i);
        data tmp_Wine_IT;
        	set tmp_Wine_IT;
			format &j translate.;
        run;
    %end;
%mend;
%translate;

DATA Translated_Wine_IT;
	SET tmp_Wine_IT;
RUN;



/*add the dummy variables*/
DATA DUMMIFIED_WINE_IT;
	SET TRANSLATED_WINE_IT;
	REASON_PARTY = 0;
	REASON_GIFT = 0;
	REASON_HOME = 0;
	REASON_TRY = 0;
RUN;

/*split the reasons in the dummy variables*/
data DUMMIFIED_WINE_IT (DROP = I);
	set DUMMIFIED_WINE_IT;
	do i = 1 to countw(BUYING_REASON, ", ");
		%let reason = STRIP(scan(BUYING_REASON, i, ","));
		IF &reason = "Home consumption" or &reason = "Consumo casalingo" THEN REASON_HOME = 1;
		ELSE IF &reason = "To buy a gift" OR &reason = "Per un regalo" then reason_gift = 1;
		ELSE IF &reason = "For a special event/party" or &reason = "Per un evento speciale/una festa" then reason_party = 1;
		ELSE IF &reason = "To try a new wine" OR &reason = "Per provare un nuovo vino" THEN reason_try = 1;
		ELSE IF &REASON NE "" THEN reason_try = &REASON;
	end;
run;

/* we consider just the first 120 rowa */ 
DATA DUMMIFIED_WINE_IT_sub;
set DUMMIFIED_WINE_IT ;
if _N_ <= 120 then output;
run; 
proc print data= DUMMIFIED_WINE_IT_sub;run;

/* create a temporary tmp_wine_en*/
data tmp_Wine_EN;
	set Wine_EN;
run;
/* adding dummy */
DATA DUMMIFIED_WINE_EN;
	SET tmp_Wine_EN;
	REASON_PARTY = 0;
	REASON_GIFT = 0;
	REASON_HOME = 0;
	REASON_TRY = 0;
RUN;

/*split the reasons in the dummy variables*/
data DUMMIFIED_WINE_EN (DROP = I);
	set DUMMIFIED_WINE_EN;
	do i = 1 to countw(BUYING_REASON, ", "); /* #1 */
		%let reason = STRIP(scan(BUYING_REASON, i, ",")); /* #2 */
		IF &reason = "Home consumption" or &reason = "Consumo casalingo" THEN REASON_HOME = 1;
		ELSE IF &reason = "To buy a gift" OR &reason = "Per un regalo" then reason_gift = 1;
		ELSE IF &reason = "For a special event/party" or &reason = "Per un evento speciale/una festa" then reason_party = 1;
		ELSE IF &reason = "To try a new wine" OR &reason = "Per provare un nuovo vino" THEN reason_try = 1;
		ELSE IF &REASON NE "" THEN reason_try = &REASON;
	end;
run;

PROC PRINT DATA=DUMMIFIED_WINE_EN;
RUN;

/*consider the first 45 rows*/
DATA DUMMIFIED_WINE_EN_sub;
set DUMMIFIED_WINE_EN ;
if _N_ <= 45 then output;
run;


/*now we convert variables from character to numeric */

Data final_1 (drop = ROSE_WINE SPARKLING_WINE SWEET_WINE);
Set DUMMIFIED_WINE_EN_sub;
Array old_var(3) $ ROSE_WINE SPARKLING_WINE SWEET_WINE;
Array new_var(3) var1-var3;
Do i = 1 to 3;
		new_var(i) = input(old_var(i), best.); 

label var1= 'ROSE_WINE'
var2= 'SPARKLING_WINE'
var3= 'SWEET_WINE';

rename var1= ROSE_WINE
var2= SPARKLING_WINE
var3= SWEET_WINE;

END;

run;

PROC PRINT DATA=FINAL_L;
RUN;

/* THEN WE CAN JOIN THE 2 DATASETS*/

