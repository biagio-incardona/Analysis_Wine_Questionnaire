/* import dataset */

PROC IMPORT OUT=Wine
	DATAFILE="/home/u45129182/Wine_survey_testset.xlsx"
	DBMS=XLSX REPLACE;
		OPTIONS VALIDVARNAME=V7;
RUN;

/*making column names meaningful*/
DATA Wine_Renamed;
SET Wine;
RENAME  A1 = like_drinks_wine_1_4
		A2 = like_drinks_beer_1_4
		A3 = like_drinks_softdrinks_1_4
		A4 = like_drinks_cocktails_1_4
		A5 = like_wine_white_1_4
		A6 = like_wine_rose_1_4
		A7 = like_wine_red_1_4
		A8 = like_wine_sparkling_1_4
		A9 = like_wine_sweet_or_liqueur_1_4
		A10 = wine_tasting_exp_bool
		A11 = visited_winery_bool
		A12 = wine_course_bool
		A13 = wine_knowledge_none_high
		B1 = wine_shop_avg_frequency_month
		B2 = wine_shop_avg_amount_month
		B3 = buy_frequency_supermarket_1_4
		B4 = buy_frequency_winery_1_4
		B5 = buy_frequency_online_1_4
		B6 = relevant_feature_origin_1_4
		B7 = relevant_feature_grape_var_1_4
 		B8 = relevant_feature_cost_1_4
 		B9 = relevant_feature_brand_1_4
 		B10 = relevant_feature_vintage_1_4
 		B11 = relevant_feature_info_1_4
 		B12 = relevant_feature_packaging_1_4
 		B13 = relevant_feature_promotion_1_4
 		B14 = wine_avg_expenditure_bottle
 		B15 = pandemic_wine_habits_changed
 		B16 = reasonS_wine_shopping_3_months
 		C1 = ever_heard_etna_wine
 		AF = ever_bought_etna_wine
 		C2 = preference_etna_over_others_1_4
 		C3 = agreement_etna_good_flavor
 		C4 = agreement_sponsor_siciliy_excel
 		C5 = agreement_etna_more_expensive
 		C6 = agreement_etna_quality_increased
 		C7 = likelihood_recommend_etna_wine
 		D1 = gender
 		D2 = age
 		D3 = education
 		D4 = origin
 		D5 = occupation;
run;

/*remove labels*/
proc datasets lib=work memtype=data;
   modify Wine_Renamed;
     attrib _all_ label=' ';
run;