/* take original dataset minus demographic and unused columns*/


/*transform all the columns into a compatible form to apply dichotomus latent class analys*/
/*the logic of the macro is the following:
	for each variable:
		1. extract distinct values (i.e 1, 2, 3, 4, 5)
		2. calculate the median of the distinct values (median(1,2,3,4, 5) = (5+1)/2 = 3)
		3. assign 1 if the value is lower than or equal the median, 2 if the value is higher than the median
*/
%macro lca_transform;
	data lca_transformed;
	set dataset(drop= DateTime Version Gender Age Education Location Job Buying_reason Age_Class);
	run;
	proc sql;
     	select name into :vname separated by ' '
     	from dictionary.columns
    	where MEMNAME='LCA_TRANSFORMED' and name <> 'AS' and name <> 'AT' and name <> 'AU' and name <> 'AV' and name <> 'AW'  and name <> 'AX';
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

/*apply LCA several times for nclass from 1 to 10*/
%macro class (num);*allow to change part of the code;
	proc lca data = lca_transformed outest=lca_outest&num;
		nclass &num; 
		nstarts 300; *start again for more precise computations;
		cores 15; *faster computation;
		ITEMS _ALL_;
		categories 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2; 
		seed 87149;*random seed;
		rho prior=1 ; 
	run;
%mend;

%macro apply;
	%do i=1 %to 10;
		%class(&i);
		data lca_outest&i;
		set lca_outest&i;
		nclass=&i;
		run;
	%end;
	data lca_comparison;
	set lca_outest1-lca_outest10;
	run;
%mend;

%lca_transform;
%apply;


PROC PRINT DATA=LCA_COMPARISON NOOBS LABEL;
label nclass = "Number of Classes" log_likelihood="LL";
var nclass log_likelihood aic bic;
run;

proc sgplot data=lca_comparison;
series x=nclass y=aic / lineattrs=(color=blue);
series x=nclass y=bic / lineattrs=(color=orange);
keylegend / title="";
scatter x=nclass y=aic / filledoutlinedmarkers markerattrs=(symbol=circleFilled) markeroutlineattrs=(color=blue);
scatter x=nclass y=bic / filledoutlinedmarkers markerattrs=(symbol=circleFilled) markeroutlineattrs=(color=orange);
run;
