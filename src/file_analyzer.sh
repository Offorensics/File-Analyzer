#!/bin/bash

######################################################################################
# License: GNU General Public License v.3.0                                          #
# Day of creation: November 16th, 2017                                               #
# Author: offorensics.com                                                            #
#                                                                                    #
# file_analyzer.sh, forensics tool for bash shell                                    #
# Visit origin at www.offorensics.com                                                #
######################################################################################

email_regex="\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b"
phone_regex="(\+1\.)?\(?[0-9]{3}\)?( |\.|-)[2-9][0-9]{2}( |\.|-)[0-9]{4}"

#Internal Field Separator (IFS) is set to newline
IFS=$'\n'
if [ "$#" -eq "2" ];then

	if [ "$1" = "email" ]; then
		regex=$email_regex
	elif [ "$1" = "phone" ]; then
		regex=$phone_regex
	else
		echo "Unknown option. Try 'email' or 'phone'"
	fi

	#reading filenames one at a time
	find "$2" | while read file_name
	do
		#unzipping a file and searching for pattern 
		search_f=$(unzip -p "$file_name" 2> /dev/null |grep -E -soa "$regex" |tr "\n" " ")
		if [ ! -z "$search_f" ];then
			if [ ! -z $(echo $search_f |awk '{print $2}') ];then
				echo "$file_name: $search_f"
			else
				echo "$file_name: $search_f"
			fi      
		else
			#searching for pattern
			search_f=$(zgrep -E -soa "$regex" "$file_name" |tr "\n" " ")
			if [ ! -z "$search_f" ];then
				if [ ! -z $(echo $search_f |awk '{print $2}') ];then
					echo "$file_name: $search_f"
				else
					echo "$file_name: $search_f"
				fi
			fi
		fi
	done

else
	echo "Usage: $0 <option> <directory>"
	exit 1
fi
