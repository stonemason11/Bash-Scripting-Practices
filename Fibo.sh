#!/bin/bash

# Fibonacci sequence
#+ Fibo(j) = Fibo(j-1)+Fibo(j-2)

if [ -z $1 ]
then
	echo "Usage: `basename $0` index(integer)!"
	exit 65
fi

idx=$1

Fibo(){
	if [ $1 -lt 0 ]
	then
		 exit 
	else
		declare a b c
		case $1 in
		0) c=0;;
		1) c=1;;
		*) 
			a=$( Fibo $[$1-1] )
			b=$( Fibo $[$1-2] )
			c=$((a + b))
		;;
		esac
	fi
	echo  $c
}

Fibo $idx

exit

