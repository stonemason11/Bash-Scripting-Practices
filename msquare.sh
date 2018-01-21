#!/bin/bash
# msquare.sh
# Magic Square generator (odd-order squares only)

# Author: Mendel Cooper
# Definition:
#	In a magic square, the summation of each row, each column, or each diago	nal equals to the same number.
# EXAMPLE:
# 8 1 6
# 3 5 7
# 4 9 2

# Globles
EVEN=2
MAXSIZE=31 # 31 rows x 31 cols
E_usage=91
dimension=
declare -i square

usage_message(){
  echo "Usage:$0 order"
  echo " ... where \"order\" (square size) is an ODDecho "
  echo "   in the range 3 - 31."
# Actually works for squares up to order 159,
#+ but large squares will not display pretty-printed
# Try increasing MAXSIZE, above.
exit $E_usage
}

function calculate() {

 local row col index dimadj j k cell_val=1
 dimension=$1

 let "dimadj = $dimension * 3 "; let "dimadj /= 2 " # x 1.5, then truncate
 
 for ((j=0; j<dimension; j++))
 do
	for ((k=0; k < dimension; k++))
	do
  		let "col = $k - $j + $dimadj"; let "col %= $dimension"
		let "row = $j * 2 - $k + $dimension"; let "row %= $dimension"
		let "index = $row*($dimension) + $col"
		square[$index]=cell_val; ((cell_val++))
	done
done
}
 # Plain math, visualization not required.
print_square ()
{
	local row col idx d1
	let "d1 = $dimension - 1"
	# Output square, one row at a time.
	# Adjust for zero-indexed array.
	for row in $(seq 0 $d1)
	do
		for col in $(seq 0 $d1)
		do
			let "idx = $row * $dimension + $col"
			printf "%3d " "${square[idx]}"; echo -n "  "
		done
		echo
	done
}

#Advanced Bash-Scripting Guide
# Displays up to 13th order neatly in 80-column term window.
# Newline after each row.
#################################################
if [[ -z "$1" ]] || [[ "$1" -gt $MAXSIZE ]]
then
usage_message
fi
let "test_even = $1 % $EVEN"
if [ $test_even -eq 0 ]
then
 # Can't handle even-order squares.
usage_message
fi
calculate $1
print_square
# echo "${square[@]}"
 # DEBUG
exit $?

