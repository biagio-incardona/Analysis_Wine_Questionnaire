/*RUN AFTER LOAD_AND_RENAME*/
/*CONVERT THE AGE VARIABLE INTO A CATEGORICAL VARIABLE WITH 5 CLASSES*/

DATA Wine_Age_Cat;
SET Wine_Renamed;
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