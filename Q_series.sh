#!/bin/bash

# Douglas Hofstadter's notorious "Q-Series":
# Q(0) = Q(1) = 1
# Q(n) = Q(n-Q(n-1)) + Q(n-Q(n-2)), for n > 2

if [ -z $1 ]
then
	echo "Usage:`basename $0` index(integer > 0 )!"
	exit
fi

n=$1

Q_S()
{
	if [ $1 -le 0 ]
	then
		exit
	else

		case $1 in
		#"") exit ;;
		"1" | "2") c=1;;
		#"2") c=1;;
		*) 
			local a b c d e
			a=$(Q_S $[$1-1])
			b=$(Q_S $[$1-2])
			d=`Q_S $[$1 - $a]`
			e=$(Q_S $[$1 - $b])
			let "c = d + e"
		;;
		esac
		echo $c
	fi
}


Q_S $n

#for i in $(seq 20)
#do
#	Q_S $i
#done

exit 0
