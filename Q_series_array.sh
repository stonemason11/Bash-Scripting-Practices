#!/bin/bash

# another implementation of Q_Series using array 
# instead of using recursive function 

if [ -z $1 ] 
then 
	echo "Usage: `basename $0` index(integer>0)"
	exit
fi

n=$1

declare -a Q



print_Q(){
for ii in `seq $1`
do
	echo  "${Q[$ii]}"
done
}

Cal_Q(){
Q[1]=1
Q[2]=1
for ii in `seq 3 $1`
do
	declare a b c d
	d=${Q[$[$ii-2]]}
	c=${Q[$[$ii-1]]}
	a=${Q[$[$ii-$c]]}
	b=${Q[$[$ii-$d]]}
	
	Q[$ii]=$((a+b))
done
}

Cal_Q $1
print_Q $1

