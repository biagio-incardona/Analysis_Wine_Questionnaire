/*PREPROCESSING FOR ANALYSIS OF CORRESPONDENCE*/

DATA data_correspondence;
SET dataset;
IF ETNA_PREFERENCE = 1 THEN
	etnapreference = "Very_Low";
ELSE IF ETNA_PREFERENCE = 2 THEN
	etnapreference ="Low";
ELSE IF ETNA_PREFERENCE = 3  THEN
	etnapreference = "High";
ELSE 
	etnapreference = "Very_High";
RUN;


ods graphics on;

/*Finding correlation between the variable gender and etna wine preferences*/

TITLE "Is there a connection between gender and Etna Wine Preference?";

PROC SGPLOT DATA=data_correspondence;
VBAR etnapreference / group=online_lessons transparency=0.5;
RUN;

PROC FREQ DATA=df_correspondence; 
TABLES etnapreference*GENDER /  nopercent norow nocol
			OUT=CONTEGGIO_FREQ
 			CHISQ
		   	SPARSE;
RUN;


PROC CORRESP DATA=data_correspondence
             ALL
		     PRINT=PERCENT 
			short plot(flip)	
			DIMENS=1
			 OUTC=COOR;
TABLE etnapreference, GENDER;
RUN;
