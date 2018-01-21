#!/bin/bash
# Random password generator by Antek Sawicki

MATRIX=`echo {0..9} | sed 's/ //g'`
MATRIX=$MATRIX`echo {A..Z}| sed 's/ //g'`
MATRIX=$MATRIX`echo {a..z}| sed 's/ //g'`

echo $MATRIX

LENGTH="8"

while [ ${n:=1} -le "$LENGTH" ]; do
#	:= default substitution
	PASS=$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}
	# ${var:pos:len} expansion
	# ${#var}: length of variable
	# $RANDOM: generate a random number

	#echo $PASS
	let "n += 1"
done

echo "$PASS"

exit 0
