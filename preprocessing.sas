/* import datasets */

%let biagio_path_pc = "C:\Users\biagi\Desktop\university\Second Year\First Semester\questionnaire\project\Analysis_Wine_Questionnaire\WINE_SURVEY_RESPONSES.xlsx";
%let biagio_path_web = "/home/u45129182/New Folder/WINE_SURVEY_RESPONSES.xlsx";
%let gianluigi_path = "C:\Users\utente\Desktop\Analysis of Questionnaire Data\WINE_SURVEY_RESPONSES.xlsx";
%let anna_path="C:\Users\Annabelle\Downloads\WINE_SURVEY_RESPONSES.xlsx";

PROC IMPORT OUT=Wine_IT
	DATAFILE=&anna_path
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="IT";
RUN;

PROC IMPORT OUT=Wine_EN
	DATAFILE=&anna_path
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="EN";
RUN;

PROC IMPORT OUT=Naming_Convention
	DATAFILE=&anna_path
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="NAMING CONVENTION";
RUN;

/*resize datasets*/

DATA WINE_IT_sub;
set WINE_IT;
if _N_ <= 120 then output;
run; 

DATA WINE_EN_sub;
set Wine_EN;
if _N_ <= 45 then output;
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
	 "60€ o pi€"  = "60€ and more "
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
 

DATA Translated_Wine_IT_sub;
	SET tmp_Wine_IT;
RUN;


/*now we convert variables from character to numeric the english version*/

Data COL_CONVERTED_EN (drop = WHITE_WINE RED_WINE ROSE_WINE SPARKLING_WINE  );
Set WINE_EN_sub;
Array old_var(4) $ WHITE_WINE RED_WINE ROSE_WINE SPARKLING_WINE ;
Array new_var(4) var1-var4;
Do i = 1 to 4;
		new_var(i) = input(old_var(i), best.); 

label var1= 'WHITE_WINE'
var2= 'RED_WINE'
var3= 'SWEET_WINE'
var4= 'SPARKLING_WINE';

rename var1= WHITE_WINE
var2= RED_WINE
var3= ROSE_WINE
var4= SPARKLING_WINE;


END;

run;
/*now we convert variables from character to numeric the italian version*/
Data COL_CONVERTED_IT (drop = WHITE_WINE  ROSE_WINE SPARKLING_WINE SWEET_WINE );
Set TRANSLATED_WINE_IT_sub;
Array old_var(4) $ WHITE_WINE ROSE_WINE SPARKLING_WINE SWEET_WINE ;
Array new_var(4) var1-var4;
Do i = 1 to 4;
		new_var(i) = input(old_var(i), best.); 

label var1= 'WHITE_WINE'
var2= 'SWEET_WINE'
var3= 'SPARKLING_WINE'
var4= 'SWEET_WINE';

rename var1= WHITE_WINE
var2= ROSE_WINE
var3= SPARKLING_WINE
var4= SWEET_WINE;


END;

run;



/*NOW WE CAN APPEND THE 2 DATASETS */

/*set all char variables to same length (don't doing this may cause truncation in the values)*/
proc sql;
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


/* i reordered the file, the last 3 columns still VERSION ROWNUM AND I i maybe we can delete if we dont use */
/* maybe also the buying reason can be useless and we could delete*/
/*the REASON_TRY is it to modify? or is it referred to the columns OTHER ?*/
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


proc print data=reordered_final_version; run;
