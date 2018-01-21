#!/bin/bash
# sd.sh Standard Deviation

count=0		# Number of data points; global
SC=9		# Scale to be used by bc. Mine decimal places
E_DATAFILE=90	# Data file error

# ---------------Set data file --------------------------

if [ ! -z "$1" ]; then
	datafile="$1"
else
	datafile=sample.dat
fi

if [ ! -e $datafile ]
then
	echo "File does not exist!"
	exit $E_DATAFILE
fi

function arith_mean()
{
	local rt=0	# Running total
	local am=0	# Arithmetic mean
	local ct=0	# Number of data points
	
	while read value
	do
		rt=$( echo "scale=$SC; $rt + $value" | bc )
		(( ct++))
	done

	am=$( echo "scale=$SC; $rt / $ct " | bc)
        echo $am
	return $ct
} <"$datafile"

sd(){
	mean1=$1	# default is global
	n=$2
	sum2=0		# sum of squared differences
	avg2=0		# Average if sum2
	sdev=0

	while read value
	do
		sum2=$(echo "scale=$SC; $sum2+($value-$mean1)^2" | bc )
	done
	avg2=$(echo "scale=$SC; $sum2 / $n" | bc)
	sdev=$(echo "scale=$SC; sqrt($avg2)" | bc )
	echo $sdev 
	return		# the return function can only return integers 
} <"$datafile"

# ======================================================= #
mean=$(arith_mean); count=$?
# Two returns from function!
std_dev=$(sd $mean $count)

# because the "sd" function runs as command substitution
# thus the variables are not visible (subshell)?

#echo "testing if avg2 is global or local..."
#echo "$avg2"

# However, if we do sd $mean $count
# then $avg2 is visible

echo
echo "Number of data points in \""$datafile"\" = $count"
echo "Arithmetic mean (average) = $mean"
echo "Standard Deviation = $std_dev"
echo
# ======================================================= #
exit


