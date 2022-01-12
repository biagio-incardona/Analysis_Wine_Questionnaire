/*RUN AFTER AGE_CATEGORICAL*/
/*remove minors if any*/

DATA No_Minors;
SET Wine_Age_Cat;
IF Age_Class = "minor" THEN
	DELETE;
RUN;