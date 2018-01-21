#!/bin/bash

# Arabic number to Roman numeral conversion
# Range: 0 - 200
# It's crude, but it works

# Extending the range and otherwise improving the script is left as an excercise.
# Usage: roman number-to-convert

LIMIT=200
E_ARG_ERR=65
E_OUT_OF_RANGE=66

if [ $# -ne 1 ]
then
	echo "Usage: `basename $0` number-to-convert" 
	exit $E_ARG_ERR
else
	if [ $1 -gt $LIMIT ]
	then
		echo "input number out of range"
		exit $E_OUT_OF_RANGE
	fi
fi

num=$1

to_roman() {
	number=$1
	factor=$2
	rchar=$3
	let "remainder = number - factor"
	while [ "$remainder" -ge 0 ]
	do
		echo -n $rchar
		let "number -= factor"
		let "remainder = number -factor"
	done
	return $number
}

to_roman $num 100 C
num=$?

to_roman $num 90 LXXXX
num=$?

to_roman $num 50 L
num=$?

to_roman $num 40 XL
num=$?

to_roman $num 10 X
num=$?

to_roman $num 9 IX
num=$?
to_roman $num 5 V
num=$?
to_roman $num 4 IV
num=$?
to_roman $num 1 I
# Successive calls to conversion function!
# Is this really necessary??? Can it be simplified?
echo
exit
