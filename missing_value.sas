/*RUN AFTER load_and_translate*/
/*HANDELING MISSING VALUE*/
/*Imputing Categorical values: WINE_BOTTLES BOTTLE_BUDGET buying_reason etna_buying gender 
	EDUCATION L19OCATION JOB */

data wine_categorical;
	set a;
 	Orig_WINE_BOTTLES = WINE_BOTTLES;
	if missing(WINE_BOTTLES) then WINE_BOTTLES = 0; /* replace 0 with mode*/
	
run;

/*Imputing Continus values: 
	SuperMarket Wine_Shop Online_Shop Grape_Origin Grape_Variety Budget_Friendly Brand_awerness Vintage 
	Label_info packing promotion buying_frequency etna_prefrances etna_flavor SICILIAN_EXCELLENCES 
	ETNA_EXPENSIVE ETNA_QUALITY ETNA_RECOMMENDATION age*/
 
proc stdize data=wine_categorical out=wine_continus 
      oprefix=Orig_         
      reponly      
	  method= MEAN;          /* or MEDIAN*/
   var  SuperMarket--promotion 
		buying_frequency 
		ETNA_PREFERENCE--ETNA_RECOMMENDATION 
		age; 
run;
/* Round Imputed Values*/
data wine_imputed;
	set wine_continus;
	array continus_variables[19]SuperMarket--age;
	do i=1 to 19;
		continus_variables[i] = round(continus_variables[i]);
	end;
	drop i;
run;



