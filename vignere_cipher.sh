#!/bin/bash
# vigenere_cipher.sh
# Author: Wensheng Sun
# wsun3@mtu.edu

Default_key="gronsfeldk"	# change this to your own key
E_NARGS=76

klen=${#Default_key}
key=`echo $Default_key | tr [a-z] [A-Z]`

alpha=(ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)
declare -A index
i=0
for (( i=0; i < ${#alpha}; i++)); do
  index[${alpha:$i:1}]=$i
done

#echo "${index[1]} ++++++++"
#echo ${key:3:1}

function encode(){
  local mlen msg idx tmp
  msg=`echo $1 | tr [a-z] [A-Z]`
  mlen=${#msg} 
  
  for ((idx=0; idx<mlen ; idx++));do
	let " tmp= $idx % $klen"
	#echo "$tmp----${key:$tmp:1}---------${msg:$idx:1}"
  	let "ind = ${index[${key:$tmp:1}]} + ${index[${msg:$idx:1}]}"
	let " ind = ind % ${#alpha} "
	echo -n ${alpha:$ind:1}
  

  done
	echo
}

function decode(){
  local mlen msg idx tmp
  msg=`echo $1 | tr [a-z] [A-Z]`
  mlen=${#msg} 
  echo -n "++"
  for ((idx=0; idx<mlen ; idx++));do
	let " tmp= $idx % $klen"
	#echo "$tmp----${key:$tmp:1}---------${msg:$idx:1}"
  	let "ind = ${index[${msg:$idx:1}]} -  ${index[${key:$tmp:1}]} "
	let "ind +=${#alpha}"
	let " ind = ind % ${#alpha} "
	echo -n "${alpha:$ind:1}"
  done
	echo

}



# main function
if [[ "$#" -eq "0" || "$#" -gt "2" ]];then
  echo "Usage:$0 [-d] texttoencode"
  exit $E_NARGS
elif [[ $# -eq 2 && "$1" = '-d' ]]; then
   D_flag=ON
   MSG=$2
elif [[ $# -eq 1 ]];then
  D_flag=OFF
  MSG=$1
else
  exit $E_NARGS
fi


if [ $D_flag = 'ON' ]; then decode $MSG; fi
if [ $D_flag = 'OFF' ]; then encode $MSG; fi

exit $?





