#!/bin/bash
# bingo.sh
# Bingo number generator

MIN=1	# Lowest allowable bingo number
MAX=75	# Highest allowable bingo number
COLS=15	# Number in each column (B I N G O)
SINGLE_DIGIT_MAX=9

declare -a Numbers
Prefix=(B I N G O)

initialize_Numbers(){
  # Zero them out to start
  # They'll be incremented if chosen
  local index=0
  until [ "$index" -gt $MAX ]
  do
    Numbers[$index]=0
    ((index++))
  done

  Numbers[0]=1	# Flag zero, so it won't be selected
}

generate_number(){
  local number

  while [ 1 ]; do
    let "number = $( expr $RANDOM % $MAX)"
    if [ ${Numbers[number]} -eq 0 ]	# Number not yet called # number is declared , thus no $ needed
    then
	let "Numbers[number] +=1"
	break
    fi
  done

  return $number
}

print_numbers_called(){
  local pre2=0	# Prefix a zero, so columns will align on single-digit numbers
  echo "Number Stats"

  for (( index=1; index<$MAX; index++))
  do
    count=${Numbers[index]}
    let "t=$index -1"
    let "column = $( expr $t / $COLS)"
    pre=${Prefix[column]}

    if [ $(expr $t % $COLS) -eq 0 ]; then
      echo
    fi

    if [ "$index" -gt $SINGLE_DIGIT_MAX ] 
    then
	echo -n "$pre$index#$count"
    else
	echo -n "$pre$pre2$index#$count"
    fi
  done
}

# main(){

RAMDOM=$$	# Seed random number generator
initialize_Numbers	# Zero out the number tracking array

clear
echo "Bingo Number Caller"; echo

while [[ "$key" != "q" ]]; do
  read -s -n1 -p "Hit a key for the next number [q to exit]" key
  # -s: silent mode, -n1: number of chars, -p: prompt
  echo
 
  generate_number; new_number=$?
  
  let "column = $(expr $new_number / $COLS)"
  echo -n "${Prefix[column]} " #B-I-N-G-O
  
  echo $new_number
done

echo; echo

# Game over...
print_numbers_called
echo; echo "[#0 = not called . . . #1 = called]"

echo
exit 0
#}

