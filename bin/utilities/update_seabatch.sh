#!/bin/bash




###########################################################################
###########################################################################
#Source the file ${SEABATCH_CONFIGURATION_DIRECTORY}'/seabatch_functions.cfg.'

source ${SEABATCH_CONFIGURATION_DIRECTORY}'/seabatch_functions.cfg'
###########################################################################
###########################################################################




###########################################################################
###########################################################################
clear

seabatch_statement "Running the SeaBatch update script ..."
echo ''
seabatch_statement "- NOTE: In order to update SeaBatch you must have git (http://git-scm.com/) installed and be connected to the internet."
echo ''
seabatch_statement "- Do you wish to continue?"
echo ''
seabatch_statement "- If YES, then the update will continue."
echo ''
seabatch_statement "- If NO, then the update will be quit."

seabatch_prompt
###########################################################################
###########################################################################




###########################################################################
###########################################################################
if [ $RESPONSE = 'NO' ]; then

	echo ''
	seabatch_statement "Quitting the SeaBatch update script ..."
	exit
	
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
clear

seabatch_statement "Updating SeaBatch ..."

cd $SEABATCH_REPO

echo ''
git pull

echo ''
seabatch_statement "SeaBatch update finished!"
echo ''
seabatch_statement "Quitting the SeaBatch update script ..."
###########################################################################
###########################################################################
