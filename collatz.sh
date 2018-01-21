#!/bin/bash
# collatz.sh

# the notorious "hailstone" or Collatz series
# ---------------------------------------------
# 1) Get the integer "seed" from the command-line
# 2) Number <- seed
# 3) Print Number
# 4) if Number is even, divide by 2, or
# 5)+ if Odd, multiply by 3 and add 1
# 6) Number <-result
# 7_) Loop back to step 3 (for specified number of iterations)

# The theory is that every such sequence, 
# no matter how large the initial value
# eventuallly settles down to repeating :4,2,1..." cycles
# even after fluctuating through a wide range of values

# This is an instance of an "iterate,"
# an operation that feeds its output back into its input
# Sometimes the result is a "chaotic" series

MAX_ITERATIONS=200

#if [ -z $1 ]; then
#	echo "Usage: `basename $0` integer"
#	exit $E_BADARGS
#fi

h=${1:-$$} # use pid process as default

echo 
echo "C($h) -*- $MAX_ITERATIONS Iterations"
echo

for (( i=1; i<=MAX_ITERATIONS; i++ ))
do
COLWIDTH=%7d
printf $COLWIDTH $h

	let "remainder = h % 2"
	if [ $remainder -eq 0 ]; then
		let "h /= 2"
	else
		let "h = 3*h + 1"
	fi

COLUMNS=10 # output 10 values per line
let "line_break = i % $COLUMNS"
if [ $line_break -eq 0 ]
then
	echo
fi

done
echo 

exit 0
