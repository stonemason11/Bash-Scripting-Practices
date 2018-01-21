#!/bin/bash
# find-splitpara.sh
# Finds split paragraphs in a text file,
#+ and tags the line numbers.

ARGCOUNT=1	# Expect one argument
OFF=0		# Flag states
ON=1
E_WRONGARGS=85

file="$1"
lineno=1
Flag=$OFF

if [ $# -ne $ARGCOUNT ]; then
  echo "USAGE: `basename $0` FILENAME"
  exit $E_WRONGARGS
fi

file_read()
{
 while read line
 do
   if [[ "$line" =~ [a-z0-9] && $Flag -eq $ON ]] # =~ regular expression (used in [[ ]] )
   then 
      echo -n "$lineno:: "
      echo "$line"
      Flag=$OFF
   fi
   
   if [[ "$line" =~ ^$ ]]
   then
     #echo "-----------------------------"
     Flag=$ON
   else
     Flag=$OFF
   fi
   ((lineno++))
 done
} < $file	# redirect file into function's stdin

file_read

exit $?

: <<qwert
# ----------------------------------------------------------------
This is line one of an example paragraph, bla, bla, bla.
This is line two, and line three should follow on next line, but
there is a blank line separating the two parts of the paragraph.
# ----------------------------------------------------------------
Running this script on a file containing the above paragraph
yields:
4::
there is a blank line separating the two parts of the paragraph.
There will be additional output for all the other split paragraphs
in the target file.
qwert

