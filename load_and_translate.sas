/* import dataset */

PROC IMPORT OUT=Wine_IT
	DATAFILE="/home/u45129182/New Folder/WINE_SURVEY_RESPONSES.xlsx"
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="IT";
RUN;

PROC IMPORT OUT=Wine_EN
	DATAFILE="/home/u45129182/New Folder/WINE_SURVEY_RESPONSES.xlsx"
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="EN";
RUN;

PROC IMPORT OUT=Naming_Convention
	DATAFILE="/home/u45129182/New Folder/WINE_SURVEY_RESPONSES.xlsx"
	DBMS=XLSX REPLACE;
	OPTIONS VALIDVARNAME=V7;
	SHEET="NAMING CONVENTION";
RUN;


/*TRANSLATE ITALIAN DATASET TO ENGLISH*/

proc sql noprint;
select 'Naming_convention'n into :collist separated by ' ' 
from Naming_Convention nc;
quit;

%let len = %sysfunc(countw(&collist));

data a;
	set Wine_IT;
run;

proc format;
value $translate
	"Mai assaggiato"="Never tasted"
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
	 "Consumo casalingo"  = "Home consumption "
	 "Per un regalo"  = "To buy a gift "
	 "Per un evento speciale/una festa"  = "For a special event/party "
	 "Per provare un nuovo vino"  = "To try a new wine "
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
	
	

%macro translate;
	/*implement: define hash table specifying keys and values*/
    %do i = 1 %to &len;
        %let j = %scan(&collist,&i);
        data a;
        set a;
		/*implement: if the element in column j is in the set of keys, then substitute it with the
		correspective in the hash table*/
		format &j translate.;
        keep &collist;
        run;
    %end;
%mend;
%translate;



