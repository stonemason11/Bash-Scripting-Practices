#!/bin/bash
# gronsfeld.sh

# Global variables
Enc_suffix="29379" # Encrypted text output with this 5-digit suffix
			# This functions as a decryption flag
			# and when used to generate passwords adds security
Default_key="gronsfeldk"
			# The script uses this if key not entered below
			# (at "Keychain")
			# Change the above two values frequently
			# for added security

GOURPLEN=5		# Output in groups of 5 letters, per tradition
alpha1=( abcdefghijklmnopqrstuvwxyz )
alpha2=( {A..Z} )	# Output in all caps, per tradition

wraplen=26		# Wrap around if past end of alphabet
dflag=			# Decrypt falg (set if $Enc_suffix presents).
E_NOARGS=76		# Missing command-line args?
DEBUG=77		# Debugging flag
declare -a offsets	# This array holds the numeric shift values for 
			# encryption/decryption

########### Keychain############
key=  		# Put key here
		# 10 characters
################################

: ()
{
  # Encrypt or decrypt, depending on whether $dflag is set
  # Why ":()" as a function name? Just to prove that it can be done
  local idx keydx mlen off1 shft
  local plaintext="$1"
  local mlen=${#plaintext}
 
  for (( idx=0; idx<$mlen; idx++))
  do
	let "keydx = $idx % $keylen"
	shft=${offsets[keydx]}

	if [ -n "$dflag" ]
 	then	# Decrypt
		let "off1=$(expr index "${alpha1[*]}" ${plaintext:idx:1}) - $shft"
	else	# Encrypt
		let "off1=$(expr index "${alpha1[*]}" ${plaintext:idx:1}) + $shft"
		# Shift forward to encrypt
		#test $(( $idx % $GROUPLEN )) = 0 && echo -n " " # Groups of 5 letters
		# Comment out above line for output as a string without whitespace
		# for example, if using the script as a password generator
	fi
	
	(( off1--))
	
	if [ $off1 -lt 0 ]
	then	# catch negative indices
		let "off1 += $wraplen"
	fi
	
	((off1 %=$wraplen))	# Wrap around if past end of alphabet
	
	echo -n "${alpha2[off1]}"
  done

  if [ -z "$dflag" ]
  then
	echo "$Enc_suffix"
  else
	echo
  fi
} # End encrypt/decrypt function


# int main(){
# Check for command-line args

if [ -z "$1" ];then
  echo "Usage: $0 TEXT TO ENCODE/DECODE"
  exit $E_NOARGS
fi


if [ ${!#} == "$Enc_suffix" ];then
  # the last command-line arg
  dflag=ON
  echo -n "+"	# Flag decrypted text with a "+" for easy ID
fi

if [ -z "$key" ];then
  key="$Default_key"
fi

keylen=${#key}

for (( idx=0; idx<keylen; idx++))
do
   offsets[idx]=$(expr index "${alpha1[*]}" ${key:idx:1}) 
   ((offsets[idx]--))	# Necessary because "expr index" starts at 1
done

args=$(echo "$*" | sed -e 's/ //g' | tr A-Z a-z | sed -e 's/[0-9]//g')
# Remove whitespace and digits from command-line args
# can modify to also remove punctuation characters, if desired

: "$args"

exit $?
