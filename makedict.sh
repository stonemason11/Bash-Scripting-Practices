#!/bin/bash
# makedict.sh

# Modification of /usr/sbin/mkdict script
# Original script copyright 1993, by Alec Muffett
# This modified scirpt included in this document in a manner
# consistent with the "License" document of the "crack" package
# that the original scirpt is a part of

# This script processes text files to produce a sorted list
# of words found in the files
# This may be useful for compiling dictionaries
# and for other lexicographic purposes

E_BADARGS=85

if [ ! -r "$1" ]; then
	echo "Usage: $0 files-to-process"
	exit $E_BADARGS
fi

cat $* |				# Dump specified files to stdout
	tr A-Z a-z |			# convert to lower case
	tr ' ' '\012' | 		# change spaces to newlines
#	tr -cd '\012[a-z] [0-9]' | 	# get rid of everything non-alphanumeric

	tr -c '\012a-z' '\012' | 	# Rather than deleting non-alpha chars, change them to newlines
	
	sort | 
	uniq |
	grep -v '^#' | 			# delete lines starting with #
	grep -v '^$'			# delete blank lines

exit $?


