DATA gender_fm;
SET dataset;
IF strip(GENDER) = "Prefer not to say" THEN DELETE;
RUN;

ods graphics on;

/*Finding correlation between the variable gender and etna wine preferences*/

TITLE "Is there a connection between gender and Etna Wine Preference?";

PROC SGPLOT DATA=data_correspondence;
VBAR etnapreference / group=gender transparency=0.5;
RUN;

PROC FREQ DATA=data_correspondence; 
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


/*Finding correlation between the variable age and etna wine preferences*/

TITLE "Is there a connection between age and Etna Wine Preference?";



PROC SGPLOT DATA=data_correspondence;
VBAR etnapreference / group=Age_Class transparency=0.5;
RUN;

PROC FREQ DATA=data_correspondence; 
TABLES Age_Class*etnapreference /  nopercent norow nocol
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
TABLE Age_Class, etnapreference;
RUN;


/*Finding correlation between knowledge of wine and etna wine preferences*/

TITLE "Is there a connection between level of knowledge of wine and Etna wine preference?";



PROC SGPLOT DATA=data_correspondence;
VBAR etnapreference / group=wineknowledge transparency=0.5;
RUN;

PROC FREQ DATA=data_correspondence; 
TABLES wineknowledge*etnapreference /  nopercent norow nocol
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
TABLE wineknowledge, etnapreference;
RUN;
