/* IMPUTATION OF MISSING VALUES */
DATA DSP20.BIGMART_TRAIN_IMPUTED;
	SET DSP20.BIGMART_TRAIN;
	IF ITEM_WEIGHT=. THEN
		ITEM_WEIGHT=12.60;
RUN;
/*nmiss returns the numeric missing values*/
PROC MEANS DATA=DSP20.BIGMART_TRAIN_IMPUTED NMISS;
	VAR ITEM_WEIGHT;
RUN;
/*Convert the missing values into the medium*/
DATA DSP20.BIGMART_TRAIN_IMPUTED;
	SET DSP20.BIGMART_TRAIN_IMPUTED;
	IF OUTLET_SIZE='' THEN
		OUTLET_SIZE='Medium';
RUN;
/*categorical variable can be summarized using the freq variable*/
PROC FREQ DATA=DSP20.BIGMART_TRAIN_IMPUTED;
	TABLE OUTLET_SIZE / NOCOL NOROW NOPERCENT;
RUN;
/*converting the item into one variable*/
DATA DSP20.BIGMART_TRAIN_IMPUTED;
	SET DSP20.BIGMART_TRAIN_IMPUTED;
	IF ITEM_FAT_CONTENT='LF' THEN
		ITEM_FAT_CONTENT='Low Fat';
	IF ITEM_FAT_CONTENT='low fat' THEN
		ITEM_FAT_CONTENT='Low Fat';
	IF ITEM_FAT_CONTENT='reg' THEN
		ITEM_FAT_CONTENT='Regular';
RUN;
/*categorical variable can be summarized using the freq variable*/
PROC FREQ DATA=DSP20.BIGMART_TRAIN_IMPUTED;
	TABLE ITEM_FAT_CONTENT;
RUN;
/*run a regression*/

proc reg data=DSP20.BIGMART_TRAIN_IMPUTED;
model item_outlet_sales=item_weight item_visibility item_mrp yob ;/*(/noint)-suppresses the intercept*/
output out=b predicted=py residual=ry;
run;


data dsp20.bigmart_train;
set dsp20.bigmart_train;
YOB = 2019-Outlet_establishment_year;
run;
/*Macros for the establishment year in the data*/
%let year=2009;
proc print data=dsp20.bigmart_train_imputed;
where outlet_establishment_year= &year;
run;
