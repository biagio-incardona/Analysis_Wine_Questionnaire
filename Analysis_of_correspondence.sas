ods graphics on;

/*Finding correlation between the variable gender and etna wine preferences*/

TITLE "Is there a connection between gender and Etna Wine Preference?";

PROC SGPLOT DATA=data_correspondence;
VBAR etnapreference / group=GENDER transparency=0.5;
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
	



/*Finding correlation between the variable education and etna wine preferences*/

TITLE "Is there a connection between education and Etna Wine Preference?";



PROC SGPLOT DATA=data_correspondence;
VBAR etnapreference_ed / group=EDUCATION transparency=0.5;
RUN;

PROC FREQ DATA=data_correspondence; 
TABLES EDUCATION*etnapreference_ed /  nopercent norow nocol
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
TABLE EDUCATION, etnapreference_ed;
RUN;
	
