#!/bin/bash
# rn.sh

# The "ren" utility does a much better job of this

ARGS=2
E_BADARGS=85
ONE=1  		# for getting singular/plural right (see below)

if [ $# -ne $ARGS ]; then
	echo "Usage:`basename $0` old-pattern new-pattern"
	exit $E_BADARGS
fi

number=0	# keep tracking of how many files actually renamed

for filename in *$1*
do
	if [ -f "$filename" ]
	then
		fname=`basename $filename`
		n=`echo $fname | sed -e "s/$1/$2/"`
		mv $fname $n
		let "number += 1"
	fi
done

if [ $number -eq $ONE ]
then
	echo "$number file renamed"
else
	echo "$number files renamed"
fi

exit $?

		

