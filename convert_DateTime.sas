/*RUN AFTER REMOVE_MINORS*/
/*CONVERT DateTime FROM CHAR TO DateTime*/
DATA DateTime_Converted;
SET No_Minors;
	DateTime =input(Date,anydtdtm.);
	format DateTime datetime20.;
RUN;