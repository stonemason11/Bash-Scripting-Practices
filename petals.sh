#!/bin/bash
# Petals Around the Rose
# Wensheng Sun
# Michigan Tech
# wsun3@mtu.edu


#RANDOM=$$
show_rules(){
 echo "===================================================="
 echo "The game is called \"Petals around the rose \"."
 echo "Remember the name of the game is significant."
 echo "The answer to each puzzle can only be even, or zero!"
 echo "That's all you need to know!"
 echo "Enjoy!"
 echo "===================================================="
}

function throw_a_dice()
{
   num=$RANDOM
   dice=$(( num % 6 + 1 ))
   return $dice
}

show_a_dice(){

  case $1 in 
  6) echo " - - -  "
     echo "|o   o|"
     echo "|o   o|"
     echo "|o   o|" 
     echo " - - - "
    ;;
  1)
     echo " - - - "
     echo "|     |"
     echo "|  o  |"
     echo "|     |" 
     echo " - - - "
    ;;
  2)
     echo " - - - "
     echo "|o    |"
     echo "|     |"
     echo "|    o|" 
     echo " - - - "
 
    ;;
  3)
     echo " - - - "
     echo "|o    |"
     echo "|  o  |"
     echo "|    o|" 
     echo " - - - "
    ;;
  4)
     echo " - - - "
     echo "|o   o|"
     echo "|     |"
     echo "|o   o|" 
     echo " - - - "
    ;;
  5)
     echo " - - - "
     echo "|o   o|"
     echo "|  o  |"
     echo "|o   o|" 
     echo " - - - "
    ;;
  *)
     echo "not a dice!"
  esac
}

new_puzzle(){
    echo "=====================new puzzle====================="
    throw_a_dice; d1=$?; show_a_dice $d1
    throw_a_dice; d2=$?; show_a_dice $d2
    throw_a_dice; d3=$?; show_a_dice $d3
    throw_a_dice; d4=$?; show_a_dice $d4 
    throw_a_dice; d5=$?; show_a_dice $d5
  return 
}

petal_count(){
  local np
  case $1 in
  3) np=2;;
  5) np=4;;
  *) np=0;;
  esac
  return $np
}

get_answer(){
  petal_count $d1; n1=$?
  petal_count $d2; n2=$?
  petal_count $d3; n3=$?
  petal_count $d4; n4=$?
  petal_count $d5; n5=$?
 
  let "ans = n1 + n2 + n3 + n4 + n5"
  #echo "The answer is $ans!"
  return $ans
}

try_again(){
  echo -n "Give it another try? Enter (Y/N)"
  read end
  case $end in
  [yY]) ;;
  [nN]) AGAIN=false;;
  *) echo "Please type legal answers: 'Y' for yes, 'N' for no!"
  esac
}
 

show_rules 
sleep 5
AGAIN=true
while $AGAIN
do

	new_puzzle
	echo -n "Please enter your answer:"
	read input
	get_answer;
	if [ "x$input" = "x$ans" ]
	then
          echo
	  echo "Congratulations! Your answer $input is correct!"
          echo "----------------------------------------------------"
          try_again
	else
 	  echo
	  echo "Sorry the correct answer is $ans!"
	  echo "----------------------------------------------------"
          try_again
	fi

done
