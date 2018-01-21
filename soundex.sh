#!/bin/bash
# soundex.sh: Calculate "soundex" code for names

#===============================================
#	soundex script
# 		by
#	Mendel Cooper

ARGCOUNT=1
E_WRONGARGS=90

if [ $# -ne "$ARGCOUNT" ]
then
	echo "Usage: `basename $0` name"
	exit $E_WRONGARGS
fi

assign_value()		# assign numberical value to letters of name
{
	val1=bfpv	#'b,f,p,v'=1
	val2=cgjkqsxz
	val3=dt
	val4=l
	val5=mn
	val6=r

# Exceptionally clever use of 'tr' follows
# Try to figure out what is going on here.

value=$( echo "$1" | tr -d wh | tr $val1 1 | tr $val2 2 | tr $val3 3 | tr $val4 4 | tr $val5 5 | tr $val6 6 | tr -s 123456 | tr -d aeiouy )

# assign letter values, squeeze repearts (tr -s), 
# except when separated by vowels.
# ignore vowels, except as separators, so delete them last
# ignore 'w' and 'h', even as separators, so delete them first
#
# the above command substitution lays more pipe than a plumber <g>.
}

input_name="$1"
echo
echo "Name=$input_name"

# change all characters of name input to lowercase
# --------------------------------------------------
name=$(echo $input_name | tr A-Z a-z)
# --------------------------------------------------
# just in case argument to script is mixed case

# Prefix of soundex code: first letter of name
# --------------------------------------------------

char_pos=0	# Initialize character position
prefix0=${name:$char_pos:1}
prefix=`echo $prefix0 | tr a-z A-Z` # Uppercase 1st letter of soundex

let "char_pos += 1" # Bump character position to 2nd letter of name
name1=${name:$char_pos}

#++++++++++++++++++++++EXCEPTION PATCH++++++++++++++
# Now, we run both the input name and the name shifted one char
# to the right through the value assigning function.
# If we get the same value out, that means that the fist two characters
# of the name have the same value assigned, and the one should cancel.
# However, we also need to test whether the first letter of the name
# is a vowel of 'w' or 'h', because otherwise this would bollix things up

char1=`echo $prefix | tr A-Z a-z` # First letter of name, lowercased

assign_value $name
s1=$value
assign_value $name1
s2=$value
assign_value $char1
s3=$value
s3=9$3		# if first letter of name is a vowel
		# or 'w' or 'h'
		# then its "value" will be null (unset)
		# Therefore, set it to 9, an otherwise
		# unused value, which can be tested for

if [[ "$s1" -ne "$s2" || $s3 -eq 9 ]]
then
	suffix=$s2
else
	suffix=${s2:$char_pos}
fi

#+++++++++++++++++++++++++++++END EXCEPTION PATH++++++++++++++++++

padding=000		#Use at most 3 zeros to pad.

soun=$prefix$suffix$padding	# Pad with zeros

MAXLEN=4			# Truncate to maximum of 4 chars
soundex=${soun:0:$MAXLEN}

echo "Soundex = $soundex"

echo

# The soundex code is a method of indexing and classifying names
# by grouping together the ones that sound alike
# The soundex code for a given name is the first letter of the name
# followed by a calculated three-number code
# Similar sounding names should have almost the sanme soundex codes.

# Examples
# Smith and Smythe both have a "S-530" soundex
# Harrison = H-625
# Hargison = H-622
# Harriman = H-655

# This works out fairly well in practice, but there are numerous anomalies
#
# The U.S. Census and Certain other governmental agencies use soundex
# as do genealogical researchers.

# For more information, see the "National 
# Archives and Records Administration home page"

# Exercise:
#---------
# Simplify the "Exception Patch" section of this script

exit 0


