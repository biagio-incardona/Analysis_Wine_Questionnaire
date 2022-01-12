/*RUN AFTER CONVERT_DATETIME*/
/*UNIVARIATE ANALYSIS PLOTS*/

/*MACRO SUMMARY*/
%macro cat_summary(var_data, var_name);
	PROC FREQ DATA=&var_data;
	TABLES &var_name;
	run;
%mend

/*MACRO BARPLOT*/
%macro cat_barplot(var_data, var_name, var_title);
	PROC SGPLOT DATA=&var_data;
	title &var_title;
	HBAR &var_name / stat=percent datalabel;
	RUN;
	TITLE;
%mend

/*MACRO*/
%macro cat_univar_plots(var_data, var_name, var_title);
	%cat_summary(&var_data, &var_name);
	%cat_barplot(&var_data, &var_name, &var_title);
%mend

/**/
/*1. How much do you like the following drinks?*/
/**/

%cat_univar_plots(DateTime_Converted, like_drinks_wine_1_4, "How much do you like Wine?");
%cat_univar_plots(DateTime_Converted, like_drinks_beer_1_4, "How much do you like Beer?");
%cat_univar_plots(DateTime_Converted, like_drinks_softdrinks_1_4, "How much do you like Soft Drinks(cocacola, soda, ...)?");
%cat_univar_plots(DateTime_Converted, like_drinks_cocktails_1_4, "How much do you like cocktails?");

/**/
/*2. How much do you like the following kinds of wine?*/
/**/

%cat_univar_plots(DateTime_Converted, like_wine_white_1_4, "How much do you like white wine?");
%cat_univar_plots(DateTime_Converted, like_wine_rose_1_4, "How much do you like rose wine?");
%cat_univar_plots(DateTime_Converted, like_wine_red_1_4, "How much do you like red wine?");
%cat_univar_plots(DateTime_Converted, like_wine_sparkling_1_4, "How much do you like sparkling wine (champagne, prosecco)?");
%cat_univar_plots(DateTime_Converted, like_wine_sweet_or_liqueur_1_4, "How much do you like sweet/liqueur wine?");

/**/
/*3. Have you ever tried a wine tasting experience?*/
/**/

%cat_univar_plots(DateTime_Converted, wine_tasting_exp_bool, "Have you ever tried a wine tasting experience?");

/**/
/*4. Have you ever visited a winery?*/
/**/

%cat_univar_plots(DateTime_Converted, visited_winery_bool, "Have you ever visited a winery?");

/**/
/*5. Have you ever attended an in-depth wine course?*/
/**/

%cat_univar_plots(DateTime_Converted, wine_course_bool, "Have you ever attended an in-depth wine course?");

/**/
/*6. Which is your level of knowledge around wines?*/
/**/

%cat_univar_plots(DateTime_Converted, wine_knowledge_none_high, "Which is your level of knowledge around wines?");

/**/
/*7. How often do you buy wine on average in a month?*/
/**/

%cat_univar_plots(DateTime_Converted, wine_shop_avg_frequency_month, "How often do you buy wine on average in a month?");

/**/
/*7. How often do you buy wine on average in a month?*/
/**/

%cat_univar_plots(DateTime_Converted, wine_shop_avg_frequency_month, "How often do you buy wine on average in a month?");

/**/
/*8. How many bottles of wine do you buy on average per month?*/
/**/

%cat_univar_plots(DateTime_Converted, wine_shop_avg_amount_month, "How many bottles of wine do you buy on average per month?");

/**/
/*9. How often do you usually buy wine in the following stores?*/
/**/

%cat_univar_plots(DateTime_Converted, buy_frequency_supermarket_1_4, "How often do you usually buy wine in supermarkets?");
%cat_univar_plots(DateTime_Converted, buy_frequency_winery_1_4, "How often do you usually buy wine in wine shops/wineries?");
%cat_univar_plots(DateTime_Converted, buy_frequency_online_1_4, "How often do you usually buy wine in online shops/mobile apps?");

/**/
/*10. How much relevant are the following features when you buy wine?*/
/**/

%cat_univar_plots(DateTime_Converted, relevant_feature_origin_1_4, "How much relevant is the grape origin region when you buy wine?");
%cat_univar_plots(DateTime_Converted, relevant_feature_grape_var_1_4, "How much relevant is the grape variety when you buy wine?");
%cat_univar_plots(DateTime_Converted, relevant_feature_cost_1_4, "How much relevant is the budget friendlies when you buy wine?");
%cat_univar_plots(DateTime_Converted, relevant_feature_brand_1_4, "How much relevant is brand awarness when you buy wine?");
%cat_univar_plots(DateTime_Converted, relevant_feature_vintage_1_4, "How much relevant is vintage when you buy wine?");
%cat_univar_plots(DateTime_Converted, relevant_feature_info_1_4, "How much relevant is having detailed info on the label when you buy wine?");
%cat_univar_plots(DateTime_Converted, relevant_feature_packaging_1_4, "How much relevant is the attractivity of the packaging when you buy wine?");
%cat_univar_plots(DateTime_Converted, relevant_feature_promotion_1_4, "How much relevant are promotions when you buy wine?");

/**/
/*11. How much do you spend on a bottle of wine on average?*/
/**/

%cat_univar_plots(DateTime_Converted, wine_avg_expenditure_bottle, "How much do you spend on a bottle of wine on average?");

/**/
/*12. During the pandemic, did the frequency with which you buy wine change?*/
/**/

%cat_univar_plots(DateTime_Converted, pandemic_wine_habits_changed, "During the pandemic, did the frequency with which you buy wine change?");

/**/
/*13. For what reason have you bought wine in the last 3 months?*/
/**/

%cat_univar_plots(DateTime_Converted, reasonS_wine_shopping_3_months, "For what reason have you bought wine in the last 3 months?");

/**/
/*14. Have you ever heard about Etna DOC wine before?*/
/**/

%cat_univar_plots(DateTime_Converted, ever_heard_etna_wine, "Have you ever heard about Etna DOC wine before?");

/**/
/*15. Have you ever bought about Etna wine?*/
/**/

%cat_univar_plots(DateTime_Converted, ever_bought_etna_wine, "Have you ever bought about Etna wine?");

/**/
/*16. How much do you like Etna wines more than other wines?*/
/**/

%cat_univar_plots(DateTime_Converted, preference_etna_over_others_1_4, "How much do you like Etna wines more than other wines?");

/**/
/*17. How much do you agree with the following statements about Etna wine?*/
/**/

%cat_univar_plots(DateTime_Converted, agreement_etna_good_flavor, "statement: Etna wine has an excellent flavor");
%cat_univar_plots(DateTime_Converted, agreement_sponsor_siciliy_excel, "statement: I would like to sponsor Sicilian excellences");
%cat_univar_plots(DateTime_Converted, agreement_etna_more_expensive, "statement: Etna wines are on average more expensive");
%cat_univar_plots(DateTime_Converted, agreement_etna_quality_increased, "statement: The quality of etna wine has increased significantly in the last 10 years");

/**/
/*18. How likely are you to recommend Etna wine to your family and friends?*/
/**/

%cat_univar_plots(DateTime_Converted, likelihood_recommend_etna_wine, "How likely are you to recommend Etna wine to your family and friends?");

/**/
/*19. Please enter your gender*/
/**/

%cat_univar_plots(DateTime_Converted, gender, "Respondants gender");

/**/
/*20. Please enter your age*/
/**/

/**/
/**/
/* Eventually make another graph with the original continuous age variable*/
/**/
/**/

%cat_univar_plots(DateTime_Converted, Age_Class, "Respondants age");

/**/
/*21. Please enter your level of education*/
/**/

%cat_univar_plots(DateTime_Converted, education, "Respondants education");

/**/
/*22. Where are you from?*/
/**/

%cat_univar_plots(DateTime_Converted, origin, "Respondants origin");

/**/
/*23. What is your occupation?*/
/**/

%cat_univar_plots(DateTime_Converted, occupation, "Respondants occupation");