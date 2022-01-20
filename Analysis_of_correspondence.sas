
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


/*Finding correlation between the variable age and etna wine preferences*/

TITLE "Is there a connection between age and Etna Wine Preference?";



PROC SGPLOT DATA=data_correspondence;
VBAR Age_Class / group=online_lessons transparency=0.5;
RUN;

PROC FREQ DATA=df_correspondence; 
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
