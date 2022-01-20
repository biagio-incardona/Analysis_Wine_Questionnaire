proc export data=dataset_drop
    outfile="/home/u45129182/new2/dataset_drop.xlsx"
    dbms=xlsx;
run;

ods graphics on;
proc irt data=dataset_drop(drop = gender age education location job datetime buying_reason) plots=(scree iic tic);
run;
