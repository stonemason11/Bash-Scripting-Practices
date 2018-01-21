#!/bin/bash

LIMIT=1000
declare -a res
res[1]=2

for ii in `eval "echo {2..$LIMIT}"`
do
	# check if $ii can be divided by all previous primes
	# if not print $ii and append it to res
	# then continue
	
	status=true
	for jj in ${res[@]}
	do
		let "reminder = ii % jj"
		if [ $reminder -eq 0 ]
		then
			status=false
			break
		fi
	# debugging purpose
#		echo "jj=$jj, reminder=$reminder, status=$status"
	done

	if $status; then
		#echo -n "$ii "
		res[((${#res[@]}+1))]=$ii
	fi
done

echo ${res[@]}

exit $?

