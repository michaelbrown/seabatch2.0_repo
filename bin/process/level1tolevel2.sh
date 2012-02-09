#!/bin/bash




###########################################################################
###########################################################################
#This script processes MODIS (Aqua and Terra) and SeaWiFS Level-1A files to 
#Level-2.
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Source the file ${SEABATCH_CONFIGURATION_DIRECTORY}'/seabatch_functions.cfg
#and the contents of ${SEABATCH_DIRECTORY}'/settings'.

source ${SEABATCH_CONFIGURATION_DIRECTORY}'/seabatch_functions.cfg'

for SEABATCH_SETTINGS_FILE in $SEABATCH_DIRECTORY'/settings/'*; do
	source $SEABATCH_SETTINGS_FILE
done
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define SEABATCH_SCRIPT_NAME and SEABATCH_SCRIPT_VERSION, the name and
#version of the current script.

SEABATCH_SCRIPT_NAME=${0}
SEABATCH_SCRIPT_VERSION='2.0'

run_seabatch_script
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define SEABATCH_LOG_DIRECTORY, the name of the directory containing the
#log information of the current SeaBatch run. 

SEABATCH_LOG_DIRECTORY=${1}
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define and source SEABATCH_PARAMETER_FILE, the SeaBatch parameter file 
#that will be used which contains the user-specified processing variables.

SEABATCH_PARAMETER_FILE=${2}
source $SEABATCH_PARAMETER_FILE
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Display the processing variables used by level2tolevel3_spatialbin.sh.

echo; echo; seabatch_separator
seabatch_statement "Processing variables used by ${SEABATCH_SCRIPT_NAME}:"
echo
seabatch_statement "- SENSOR: ${SENSOR}"
echo "- L2_PRODUCTS: ${L2_PRODUCTS[@]}"
seabatch_statement "- L2_RESOLUTION: ${L2_RESOLUTION}"
seabatch_statement "- L2GEN_PARAMETER_FILE: ${L2GEN_PARAMETER_FILE}"
seabatch_separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
	###################################################################
	###################################################################
	echo; echo; seabatch_separator
	seabatch_statement "Begin Level-1 to Level-2 processing of MODIS Level-1A files ..."
	seabatch_separator
	###################################################################
	###################################################################




	###################################################################
	###################################################################
	FILE_TYPE='MODIS Level-1A files'
	FILE_TYPE_PATTERNS=$MODIS_L1A_FILE_PATTERNS
	FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l1a.txt'
			
	file_type_list
			
	if [ $FILE_TYPE_FILE_AMOUNT -eq 0 ]; then
		exit 1
	fi
	###################################################################
	###################################################################




	###################################################################
	###################################################################
	while read MODIS_L1A_FILE; do
		
		
		
		
		###########################################################
		###########################################################
		echo; echo; seabatch_separator
		seabatch_statement "Current MODIS Level-1A file: ${MODIS_L1A_FILE}"
		seabatch_separator
		###########################################################
		###########################################################
					
					
					
					
		###########################################################
		###########################################################
		#Define BASENAME, the basename of MODIS_L1A_FILE.
			
		BASENAME=$(echo $MODIS_L1A_FILE | awk -F. '{ print $1 }')
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Define GEO_FILE, the name of the geolocation file.
			
		GEO_FILE=${BASENAME}.GEO
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Construct the geolocation file using the SeaDAS script 
		#modis_GEO.py.
		
		echo; echo; seabatch_separator 
		seabatch_statement "Constructing the geolocation file (${GEO_FILE}) ..."
		seabatch_separator; echo; echo
		
		modis_GEO.py -o $GEO_FILE -v $MODIS_L1A_FILE
		
		if [ $? -ne 0 ]; then
			SCRIPT_NAME='modis_GEO.py'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $MODIS_L1A_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Define L1B_LAC_FILE, L1B_HKM_FILE, and L1B_QKM_FILE, the 
		#names of the 1 km, .5 km and .25 km Level-1 B files.
			
		L1B_LAC_FILE=${BASENAME}.L1B_LAC
		L1B_HKM_FILE=${BASENAME}.L1B_HKM
		L1B_QKM_FILE=${BASENAME}.L1B_QKM
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Process L1A_FILE from Level-1A to Level-1B using the 
		#SeaDAS script modis_L1B.py. 
		
		echo; echo; seabatch_separator
		seabatch_statement "Processing ${MODIS_L1A_FILE} from Level-1A to Level-1B (constructing ${L1B_LAC_FILE}, ${L1B_HKM_FILE}, and ${L1B_QKM_FILE}) ..."
		seabatch_separator; echo; echo
		
		modis_L1B.py -o $L1B_LAC_FILE -k $L1B_HKM_FILE -q $L1B_QKM_FILE -v $MODIS_L1A_FILE $GEO_FILE
		
		if [ $? -ne 0 ]; then
			SCRIPT_NAME='modis_L1B.py'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $MODIS_L1A_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Define ANC_FILE, the name of the ancillary file.
			
		ANC_FILE=${L1B_LAC_FILE}'.anc'
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Construct the ancillary file using the SeaDAS script 
		#getanc.py.
		
		echo; echo; seabatch_separator
		seabatch_statement "Constructing the ancillary file (${ANC_FILE}) ..."
		seabatch_separator; echo; echo
		
		getanc.py -v $L1B_LAC_FILE
		
		if [ $? -ne 0 ]; then
			SCRIPT_NAME='getanc.py'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1B_LAC_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Define L2_FILE, the name of the Level-2 file.
			
		L2_FILE=${BASENAME}.L2
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#If L2GEN_PARAMETER_FILE is set to "DEFAULT" then set it to 
		#"l2gen_modis_default.par".
	
		if [ $L2GEN_PARAMETER_FILE = 'DEFAULT' ]; then
			L2GEN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l2gen_modis_default.par'
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Process L1B_LAC_FILE from Level-1B to Level-2 using the 
		#SeaDAS script l2gen.
		
		echo; seabatch_separator
		seabatch_statement "Processing $L1B_LAC_FILE from Level-1B to Level-2 (constructing ${L2_FILE}) ..."
		seabatch_separator
		
		echo; echo; seabatch_separator
		seabatch_statement "l2gen parameter file used: ${L2GEN_PARAMETER_FILE}"
		echo
		cat $L2GEN_PARAMETER_FILE
		seabatch_separator; echo; echo
		
		l2gen ifile=$L1B_LAC_FILE geofile=$GEO_FILE ofile=$L2_FILE l2prod=${L2_PRODUCTS[@]} resolution=${L2_RESOLUTION} \
		par=$ANC_FILE \
		par=$L2GEN_PARAMETER_FILE
		
		if [ $? -ne 0 ]; then
			SCRIPT_NAME='l2gen'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1B_LAC_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Remove any intermediate files that were generated.
		
		if [ $REMOVE_GEO = 'YES' ]; then
			rm $GEO_FILE
		fi
		
		if [ $REMOVE_L1B = 'YES' ]; then
			rm *L1B*
		fi
		###########################################################
		###########################################################
		
		


	done <$FILE_TYPE_TEXT_FILE
	###################################################################
	###################################################################
	
	
	
	
	###################################################################
	###################################################################
	echo; echo; seabatch_separator
	seabatch_statement "Level-1 to Level-2 processing of MODIS Level-1A files finished!"
	seabatch_separator
	###################################################################
	###################################################################




fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
SEABATCH_SCRIPT_EXIT_STATUS=0
exit_seabatch_script
###########################################################################
###########################################################################
