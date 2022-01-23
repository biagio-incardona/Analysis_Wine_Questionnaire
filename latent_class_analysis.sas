/* take original dataset minus demographic and unused columns*/
data lca_transformed(drop= DateTime Version Gender Age Education Location Job Buying_reason Age_Class);
set dataset;
run;

/*transform all the columns into a compatible form to apply dichotomus latent class analys*/
/*the logic of the macro is the following:
	for each variable:
		1. extract distinct values (i.e 1, 2, 3, 4, 5)
		2. calculate the median of the distinct values (median(1,2,3,4, 5) = (5+1)/2 = 3)
		3. assign 1 if the value is lower than or equal the median, 2 if the value is higher than the median
*/
%macro lca_transform;
	proc sql;
     	select name into :vname separated by ' '
     	from dictionary.columns
    	where MEMNAME='lca_transformed';
	quit;
	%let len = %sysfunc(countw(&vname));
	%DO I=1 %to &len;
		%let j = %scan(&vname,&I);
		
		PROC FREQ DATA=dataset noprint;
		TABLE &j / OUT= want ;
		RUN;
		
		proc means data=want median noprint;
		var &j;
		output out=median_value median(&j)=median_val;
		run;
		
		data lca_transformed(drop=median_val);
			if _n_ = 1 then set median_value(keep=median_val);
			set lca_transformed;
			if &j  <= floor(median_val) then &j = 1;
			else &j = 2;
		run;
	%END;
%mend;
%lca_transform;

/*apply LCA several times for nclass from 1 to 10*/
%macro class (num);*allow to change part of the code;
	proc lca data = lca_transform outest=lca_outest&num;
		nclass &num;  
		nstarts 300; *start again for more precise computations;
		cores 15; *faster computation;
		categories 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2; 
		seed 87149;*random seed;
		rho prior=1 ; 
	run;
%mend;
%class(1);
