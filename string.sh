#!/bin/bash

# string.bash----bash emulation of string(3) library routines
# Author: Noah Friedman <friedman@prep.ai.mit.edu>

#: docstring strcat:
# Usage:strcat s1 s2
#: end docstring:

###;;;autoload  ===> Autoloading of function commented out.
function strcat()
{
	local s1_val s2_val
	s1_val=${!1}		# indirect variable expansion
	s2_val=${!2}
	
	eval "$1"=\'"${s1_val}${s2_val}"\'
	echo ${!1}
}

#: docstring strncat:
# Usage: strncat s1 s2 $n

# Like strcat, but strncat appends a maximum of n characters from the value
# of variable s2. It copies fewer if the value of variable s2 is shorter
# than n caracters. Echoes result on stdout
# Example:
# a=foo
# b=barbaz
# strncat a b 3
# echo $a
# foobar

function strncat()
{
	local s1 s2 s1_val s2_val
	s1=$1
	s2=$2
	s1_val=${!1}
	s2_val=${!2}
	
	local -i n="$3"

	if [ ${#s2_val} -gt ${n} ]; then
		s2_val=${s2_val:0:$n}
	fi

	eval $s1=\'"$s1_val""$s2_val"\'
	# eval $1='${s1_val}${s2_val}' avoids problems
	# if one of the variables contains a single quote
}

#: docstring strcmp
# example:
#	strcmp $s1 $s2
# Strcmp compares its arguments and returns an integer less than, equal to 
# , or greater than zero, depending on whether string s1 is lexicographically
# less than, equal to, or greater than string s2

function strcmp (){
	[ "$1" = "$2" ] && return 0
	[ "$1" '<' "$2" ] > /dev/null && return -1
	# both '<' and \< works for string comparision
	return 1
}

#: docstring strncmp
# Usage: strncmp $s1 $s2 $n
# Like strcmp, but makes the comparison by examining a maximum of n
# characters (n less than or equal to zero yields equality).
#: end docstring:

###;;;autoload
function strncmp()
{
	if [ -z "${3}" -o "${3}" -le "0" ]; then
		return 0
	fi

	if [ ${3} -ge ${#1} -a ${3} -gt ${2} ]; then
		strcmp "$1" "$2"
		return $?
	else
		s1=${1:0:$3}
		s2=${2:0:$3}
		strcmp "$s1" "$s2"
		return $?
	fi
}

#:docstring strlen:
# Usage: strlen s
# strlen returns the number of characters in string literal s
#:end docstring

###;;;autoload
function strlen()
{
	eval echo "\${#${1}}"
}


#: docstring strspn
# Usage: strcspn $s1 $s2
# strspn returns the length of the maximum initial segment of string s1,
# which consists entirely of characters from string s2
#:end docstring:

###;;;autoload
function strcspn(){
	# Unsetting IFS allows whitespace to be handles as normal chars
	local IFS=
	local result="${1%%[!${2}]*}"
	# ${string%%substring} strip longest match of $substring from back of $string
	#${string%substring} strip shortest match $substring from back of $string
	echo ${#result}
}
# strcspn "abcdefg" "abg"  ==>> 2

##:docstring strstr:
# Usage: strstr s1 s2
# Strstr echoes a substring starting at the first occurrence of string s2 in
# string s1, or nothing if s2 does not occur in the string. If s2 points to 
# a string of zero length, strstr echoes s1.
#:end docstring:

###;;;autoload
function strstr()
{	
	[ ${#2} -eq 0 ] && { echo "$1"; return 0; }

	case "$1" in
	*$2*) ;;
	*) return 1 ;;
	esac

	# use the pattern matching code to strip off the match and everything
	# following it
	first=${1/$2*/} # ${string/substring/replacement}: first match
	#{string//substring/replacement} all match
	# then strip off the first unmatched portion of the string
	echo "${1##$first}" #{string##substring} strip longest match from front of $string
}


#:docstring strtok:
# Usage: strstok s1 s2

# Strtok considers the string s1 to consist of a sequence of zero or more
# text tokens separaterd by spans of one or maore characters from the 
# separator string s2. The first call (with a non-empty string s1
# specified) echoes a string consisting of the first token on stdout. The 
# functin keeps track of its position in the string s1 between spearate 
# calls, so thant subsequent calls made with the first argument an empty 
# string will work through the string immediately following that token. In 
# this way subsequent calls will work through the string s1 until no tokens
# remain. The separator string s2 may be different from call to call.
# When no token remains in s1, an empty value is echoed on stdout.
#:enddocstring:

###;;;autoload
function strtok(){
:
}

#:docstring strtrunc
# Usage: strtrunc $n $s1 {$s2} {$...}
# Usaged by many functions like strncmp to truncate arguments for comparison
# Echoes the first n characters of each string s1 s2 ... on stdout
#:end docstring:

###;;;autoload
function strtrunc ()
{
	n=$1; shift
	for z; do 
		echo "${z:0:$n}"
	done
}

# provide string

# string.bash ends here

#==========================================================#
# Tests

# Suggested use of this script is to delete everything below here
# and "source" this file into your own scripts

# strcat
string0=one
string1=two
echo
echo "Testing\"strcat\" function:"
strcat string0 string1

# strlen
echo
echo "Testing\"strlen\" function:"
str=123456789
strlen str
echo

exit 0

