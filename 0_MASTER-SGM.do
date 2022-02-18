*****GREAT MIGRATION AND MOBILITY MASTER DO-FILE *****
**********Do-file para replicacion
**********Sebastian Guevara Molano
**********Universidad de los Andes
**********Economia Urbana 2022-1
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

0. This is the master do-file for "Can you move to opportunity? Evidence from the Great Migration", which calls all the individual do-files required to replicate the analysis conducted in this paper.

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
STEPS:
	*0. Set preconditions and directory definitions. 
	*1. Build geographic crosswalks.
	*2. Post-LASSO prediction of southern county net-migration.
	*3. Shift-share instrument for Great Migration into northern cities.
	*4. Build final analysis dataset.
	*5. Produce main tables and figures.
	*6. Produce appendix tables and figures.
	*7. Produce additional figures and slides for slide deck.
	*8. Keeps only vars that are used in analysis datasets and labels them.
*first created: 12/30/2019
*last updated: 8/12/2021
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/	

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	
*0. Set preconditions and directory definitions.
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
	
* Clear all and set max matsize. *
	capture log close
	clear all
	set more off
	set matsize 11000
	set maxvar 30000
	
* Action required: Change to path to the replication folder on your home directory. *
	global XXX 		"C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER"	
	
	* Action required: Install packages 

						ssc install estout, replace
						ssc install maptile, replace
						ssc install spmap, replace
						ssc install shp2dta, replace
						ssc install parmest, replace
						ssc install ivreg2, replace
						ssc install ranktest, replace
						ssc install statastates, replace
						ssc install mdesc, replace
						ssc install coefplot, replace
						ssc install rsource, replace
						ssc install binscatter, replace
						ssc install keeporder, replace
						ssc install lincomest, replace
						ssc install egenmore, replace
						ssc install distinct, replace
						ssc install unique, replace 
			
						maptile_install using "http://files.michaelstepner.com/geo_cz1990.zip", replace
						
	/* Action required: Install .style files (customized color palette). */
						*i. copy the .style files (located in 'color_palette' folder) to the top of your SITE or PERSONAL directory 
						*-->to get the path for either your SITE or PERSONAL directory, type in "adopath" in Stata. 
						*ii.type "discard" OR restart Stata to make sure STATA loads the new colors. 

	/* Action required: copy the ado file ri_pvalue.ado (located in `data/randomization_inference' folder) to your PERSONAL directory.
	*-->to get the path for either your PERSONAL directory, type in "adopath" in Stata.
	
	*/
	
	/* For instructions on using these replication files, see replication_aer/ReadMe.pdf. */
	/* For a list of the figures and tables  replication_aer/derenoncourt_2021_list_tables_figures.xlsx". */
		
	/* Code dir and sub-dirs. */
	global code "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/code"
	global lasso "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/lasso"
	global bartik "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/bartik"
	
	/* Data dir and sub-dirs. */
	global data "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/data"
	global xwalks "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/data/crosswalks"
	global urbrural "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/xwalks/documentation/urban_rural_county_classification"
	global msanecma "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/xwalks/documentation/msanecma_1999_codes_names"
	global city_sample "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/data/city_sample"
	global mobdata "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/data/mobility"
	global instrument "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/data/instrument"
	global migshares "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/instrument/shares"
	global migdata "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/instrument/migration"
	global mechanisms "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/data/mechanisms"
	global jobs "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/mechanisms/jobs"
	global pf "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/mechanisms/public_finance"
	global political "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/mechanisms/political"
	global nbhds "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/mechanisms/neighborhoods"
	global incarceration "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/mechanisms/incarceration"
	global schools "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/mechanisms/schools"
	global population "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/mechanisms/population"
	global ri "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/data/randomization_inference"
		
	/* Paper and slides dirs and sub-dirs. */
	global paper "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/paper"
	global figtab "C:\Users\sebsg\Documents\Para la U\Octavo\Urbana\Proyecto\Migration\replication_AER/figures_tables"
	
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	
*1. Build intermediate datasets.
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

	 do C:\Users\sebsg\Documents\ParalaU\Octavo\Urbana\Proyecto\Migration\replication_AER/code/1_build.do

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	
*2. Predict netmigration from the South between 1940 and 1970.
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

	do C:\Users\sebsg\Documents\ParalaU\Octavo\Urbana\Proyecto\Migration\replication_AER/code/2_lasso.do

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	
*3. Construct versions of shift-share instrument.
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

	 do C:\Users\sebsg\Documents\ParalaU\Octavo\Urbana\Proyecto\Migration\replication_AER/code/3_instrument.do
	
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	
*4. Assemble final dataset.
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

	do C:\Users\sebsg\Documents\ParalaU\Octavo\Urbana\Proyecto\Migration\replication_AER/code/4_final_dataset.do

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	
*5. Generate main figures and tables.
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

	do C:\Users\sebsg\Documents\ParalaU\Octavo\Urbana\Proyecto\Migration\replication_AER/code/5_main_figures_tables.do



