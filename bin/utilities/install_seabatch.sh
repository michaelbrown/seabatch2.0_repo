#!/bin/bash




##########################################################################
##########################################################################
function prompt {
	
	PROMPT_AMOUNT=1
	VALID_INPUT=NO

	while [ $VALID_INPUT = 'NO' ]; do

		if [ $PROMPT_AMOUNT -eq 1 ]; then
			echo ''
			echo -n '- Enter "y" if YES, or "n" if NO: '
			read INPUT
		fi

		if [ $PROMPT_AMOUNT -gt 1 ]; then
			echo ''
			echo -n '- Invalid response! Enter "y" if YES, or "n" if NO: '
			read INPUT
		fi
	
		case $INPUT in
	
			'y')
				VALID_INPUT='YES'
				RESPONSE='YES'
			;;
		
			'n')
				VALID_INPUT='YES'
				RESPONSE='NO'
			;;
		
			*)
				PROMPT_AMOUNT=$(( $PROMPT_AMOUNT + 1 ))

		esac
	
	done
	
}

function quit_installation {

	MANUAL_INSTALLATION=${1}

	if [ $MANUAL_INSTALLATION = 'YES' ]; then
	
		clear
	
		seabatch_statement "Steps To Perform A Manual Installation of SeaBatch"
		echo ''
		seabatch_statement "- Construct the ~/.bashrc configuration file (if it does not already exist)."
		echo ''
		seabatch_statement "- Remove any lines in the ~/.bashrc configuration file that reference SeaBatch."
		echo ''
		seabatch_statement "- Append the following lines to the ~/.bashrc configuration file:"
		echo ''
		seabatch_statement "export SEABATCH=${WORKING_DIRECTORY}"
		seabatch_statement "source ${SEABATCH}/sub/env/seabatch.env"
		
	fi
	
	break

}

function seabatch_statement {
	STATEMENT=${1}
	echo $STATEMENT | fold -s -w75
}
##########################################################################
##########################################################################




##########################################################################
##########################################################################
while true; do




	##################################################################
	##################################################################
	#Introduction.

	clear

	seabatch_statement "- Thank you for your interest in SeaBatch 2.0!" 
	echo ''
	seabatch_statement "- You will now be guided through the steps to install SeaBatch on your system."
	echo
	seabatch_statement "- Do you wish to continue the installation?"
	echo ''
	seabatch_statement "- If YES, then the installation will continue."
	echo ''
	seabatch_statement "- If NO, then the installation will be quit."

	prompt

	if [ $RESPONSE = 'NO' ]; then
		quit_installation 'NO'
	fi
	##################################################################
	##################################################################




	##################################################################
	##################################################################
	#Step 1 of 5: Construct Your SeaBatch Directory.

	clear

	HOME_DIRECTORY=~
	SEABATCH_DIRECTORY=${HOME_DIRECTORY}'/seabatch2.0'

	seabatch_statement "Step 1 of 5: Construct Your SeaBatch Directory"
	echo ''
	seabatch_statement "- It is necessary to construct your SeaBatch directory, the directory on your system into which SeaBatch will be installed."
	echo ''
	seabatch_statement "- A standard installation of SeaBatch will construct a directory named \"seabatch2.0\" in your home directory. This will be your SeaBatch directory."
	echo ''
	seabatch_statement "- On your system your home directory is: $HOME_DIRECTORY"
	echo ''
	seabatch_statement "- Therefore your SeaBatch directory will be: $SEABATCH_DIRECTORY"

	if [ -e $SEABATCH_DIRECTORY ]; then

		echo ''
		seabatch_statement "- NOTE: A directory named \"$SEABATCH_DIRECTORY\" already exists on your system. Please remove that directory and start the installation over."
	
		quit_installation 'NO'
	
	else

		echo ''
		seabatch_statement "- Do you wish to continue the installation?"
		echo ''
		seabatch_statement "- If YES, then the directory \"$SEABATCH_DIRECTORY\" will be constructed on your system. This will be your SeaBatch directory."
		echo ''
		seabatch_statement "- If NO, then the installation will be quit."

		prompt

		if [ $RESPONSE = 'NO' ]; then
			quit_installation 'NO'
		fi
	
	fi
	##################################################################
	##################################################################




	##################################################################
	##################################################################
	#Step 2 of 5: Clone The Remote SeaBatch Repository.

	clear

	SEABATCH_REPO=${SEABATCH_DIRECTORY}'/.seabatch2.0_repo'

	seabatch_statement "Step 2 of 5: Clone The Remote SeaBatch Repository"
	echo ''
	seabatch_statement "- SeaBatch 2.0 is stored in a remote repository (repo) located at git://github.com/michaelbrown/seabatch2.0_repo.git."
	echo ''
	seabatch_statement "- It is necessary to clone the above remote SeaBatch repo. It will be cloned into a hidden (.) directory named \".seabatch2.0_repo\" that will be constructed in your SeaBatch directory."
	echo ''
	seabatch_statement "- NOTE: In order to clone the above remote SeaBatch repo into your SeaBatch directory you must have git (http://git-scm.com/) installed and be connected to the internet."
	echo ''
	seabatch_statement "- Do you wish to continue the installation?"
	echo ''
	seabatch_statement "- If YES, then the directory \"$SEABATCH_REPO\" will be constructed on your system, into which the above remote SeaBatch repo will be cloned."
	echo ''
	seabatch_statement "- If NO, then the installation will be quit."

	prompt

	if [ $RESPONSE = 'NO' ]; then
		quit_installation 'NO'
	fi
	##################################################################
	##################################################################




	##################################################################
	##################################################################
	Step 3 of 5: Determine The Existence Of Your Bash Configuration File.

	clear

	CONSTRUCT_BASHRC='NO'

	seabatch_statement "Step 3 of 5: Determine The Existence Of Your Bash Configuration File"
	echo ''
	seabatch_statement "- Installation of SeaBatch on your system involves modifying your \"~/.bashrc\" configuration file."

	if [ -e ~/.bashrc ]; then

		echo ''
		seabatch_statement "- Your \"~/.bashrc\" configuration file exists. You may continue the installation."
		echo
		seabatch_statement "- Do you wish to continue the installation?"
		echo ''
		seabatch_statement "- If YES, then the installation will continue."
		echo ''
		seabatch_statement "- If NO, then the installation will be quit."
	
		prompt
	
		if [ $RESPONSE = 'NO' ]; then
			quit_installation 'NO'
		fi
	
	else 

		echo ''
		seabatch_statement "- Your \"~/.bashrc\" configuration file does NOT exist."
		echo ''
		seabatch_statement "- It is necessary to construct this file. To accomplish this the following command will be entered:"
		echo ''
		seabatch_statement "touch ~/.bashrc"
		echo
		seabatch_statement "- Do you wish to continue the installation?"
		echo ''
		seabatch_statement "- If YES, then the above command will be entered, and your \"~/.bashrc\" configuration file will be constructed."
		echo ''
		seabatch_statement "- If NO, then the installation will be quit."

		prompt

		if [ $RESPONSE = 'NO' ]; then
			quit_installation 'NO'
		fi
	
		CONSTRUCT_BASHRC='YES'	
	
	fi
	##################################################################
	##################################################################



	##################################################################
	##################################################################
	Step 4 of 5: Clean Up Your Bash Configuration File.

	clear

	CLEAN_UP_BASHRC='NO'

	seabatch_statement "Step 4 of 5: Clean Up Your Bash Configuration File"
	echo ''
	seabatch_statement "- It is necessary to remove any lines in your \"~/.bashrc\" configuration file that reference previous SeaBatch installations."
	echo ''
	seabatch_statement "- Searching your \"~/.bashrc\" configuration file ..."
	echo ''
	
	grep -i 'SEABATCH' ~/.bashrc

	if [ $? -eq 0 ]; then
	
		echo ''
		seabatch_statement "- The above lines were found. It is necessary to delete them. To accomplish this the following commands will be entered:"
		echo ''
		echo "grep -i -v \"SEABATCH\" ~/.bashrc > ~/.bashrc_new"
		echo "mv ~/.bashrc_new ~/.bashrc"
		echo
		seabatch_statement "- Do you wish to continue the installation?"
		echo ''
		seabatch_statement "- If YES, then the above commands will be entered, and your \"~/.bashrc\" configuration file will be cleaned up."
		echo ''
		seabatch_statement "- If NO, then the installation will be quit."

		prompt

		if [ $RESPONSE = 'NO' ]; then
			quit_installation 'NO'
		fi
	
		CLEAN_UP_BASHRC='YES'

	else

		seabatch_statement "- No lines were found. You may continue the installation."
		echo
		seabatch_statement "- Do you wish to continue the installation?"
		echo ''
		seabatch_statement "- If YES, then the installation will continue."
		echo ''
		seabatch_statement "- If NO, then the installation will be quit."

		prompt

		if [ $RESPONSE = 'NO' ]; then
			quit_installation 'NO'
		fi

	fi
	##################################################################
	##################################################################



	
	##################################################################
	##################################################################
	Step 5 of 5: Modify Your Bash Configuration File.

	clear

	seabatch_statement "Step 5 of 5: Modify Your Bash Configuration File"	
	echo ''
	seabatch_statement "- It is necessary to append the following lines to your \"~/.bashrc\" configuration file:"
	echo ''
	seabatch_statement "export SEABATCH_DIRECTORY=${SEABATCH_DIRECTORY}"
	seabatch_statement "export SEABATCH_REPO=${SEABATCH_REPO}"
	seabatch_statement "source ${SEABATCH_REPO}/env/seabatch.env"
	echo ''
	seabatch_statement "- To accomplish this the following commands will be entered:"
	echo ''
	echo "echo 'export SEABATCH_DIRECTORY='${SEABATCH_DIRECTORY} >> ~/.bashrc"
	echo "echo 'export SEABATCH_REPO='${SEABATCH_REPO} >> ~/.bashrc"
	echo "echo 'source \${SEABATCH}/env/seabatch.env' >> ~/.bashrc"
	echo ''
	seabatch_statement "- Do you wish to continue the installation?"
	echo ''
	seabatch_statement "- If YES, then the above commands will be entered, and your \"~/.bashrc\" configuration file will be modified."
	echo ''
	seabatch_statement "- If NO, then the installation will be quit."

	prompt

	if [ $RESPONSE = 'NO' ]; then
		quit_installation 'NO'
	fi
	##################################################################
	##################################################################




	##################################################################
	##################################################################
	#SeaBatch Installation.

	clear

	seabatch_statement "Installing SeaBatch ..."

	echo ''
	seabatch_statement "Constructing \"$SEABATCH_DIRECTORY\" ..."
	mkdir $SEABATCH_DIRECTORY ${SEABATCH_DIRECTORY}'/.usr'

	echo ''
	seabatch_statement "Constructing \"$SEABATCH_REPO\" ..."
	mkdir $SEABATCH_REPO

	echo ''
	seabatch_statement "Cloning git://github.com/michaelbrown/seabatch2.0_repo.git into \"$SEABATCH_REPO\" ..."
	git clone git://github.com/michaelbrown/seabatch2.0_repo.git $SEABATCH_REPO
	
	cp ${SEABATCH_REPO}'/usr/'* ${SEABATCH_DIRECTORY}'/.usr' $SEABATCH_DIRECTORY
	rm ${SEABATCH_DIRECTORY}'/documentation/'*'.odt'

	if [ $CONSTRUCT_BASHRC = 'YES' ]; then
	
		echo ''
		seabatch_statement "Constructing \"~/.bashrc\" ..."
		touch ~/.bashrc
	
	fi

	if [ $CLEAN_UP_BASHRC = 'YES' ]; then
	
		echo ''
		seabatch_statement "Cleaning up \"~/.bashrc\" ..."
		grep -i -v "SEABATCH" ~/.bashrc > ~/.bashrc_new
		mv ~/.bashrc_new ~/.bashrc
	
	fi

	echo ''
	seabatch_statement "Modifying \"~/.bashrc\" ..."
	echo 'export SEABATCH_DIRECTORY='${SEABATCH_DIRECTORY} >> ~/.bashrc
	echo 'export SEABATCH_REPO='${SEABATCH_REPO} >> ~/.bashrc
	echo 'source ${SEABATCH_REPO}/env/seabatch.env' >> ~/.bashrc
	
	. ~/.bashrc
	##################################################################
	##################################################################

	


	##################################################################
	##################################################################
	#Finishing up.

	clear

	seabatch_statement "Installation Successful!"
	echo ''
	seabatch_statement "- Refer to the manual for directions on how to use SeaBatch."
	echo ''
	seabatch_statement "- Contact mike@seabatch.com with any questions or suggestions."

	quit_installation 'NO'
	##################################################################
	##################################################################




done
##########################################################################
##########################################################################




echo ''
seabatch_statement "Quitting the SeaBatch installation ..."
