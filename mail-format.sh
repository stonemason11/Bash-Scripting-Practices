#!/bin/bash

# mail-format.sh
# Gets rid of carets, tabs, and also folds excessively long lines

#============================================================
# 		Standard Check for Script Argument(s)

ARGS=1;
E_BADARGS=85;
E_NOFILE=86;

if [ $# -ne $ARGS ]; then
	echo "Usage:`basename $0` filename"
	exit $E_BADARGS
fi

if [  -f "$1" ]; then
	file_name=$1
else
	echo "File \"$1\" does not exist"
	exit $E_NOFILE
fi

MAXWIDTH=70

sedscript='s/^>//
s/^  *>//
s/^  *//
s/		*//'


sed "$sedscript" $1 | fold -s --width=$MAXWIDTH

exit $? 
