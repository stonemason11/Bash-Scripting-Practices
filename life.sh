#!/bin/bash
# life.sh: "Life in the slow lane"
# Author: Mendel Cooper
# License: GPL3

# Version 0.2: Patched by Daniel Albers
#+		to allow non-square grids as input
# Version 0.2.1: Added 2-second delay between generations.

###################################################
# This is the Bash script version of John Conway's "Game of life".
# "Life" is a simple implementation of cellular automata
# -------------------------------------------------
# On a rectangular grid, let each "cell: be either "living" or "dead."
# Designate a living cell with a dot, and a dead one with a blank space
#	Begin with an arbitrarily drawn dot-and-blank grid,
#	and let this be the starting generationL generation 0
# Determine each successive generation by the following rules:
#	1) Each cell has 8 neighbors, the adjoining cells
#	left, right, top bottom, and the 4 diagonals.
#			123
#			4*5  The * is the cell under consideration.
#			678
#
#	2) A living cell with either 2 or 3 living neighbors remains alive
SURVIVE=2
#	3) A dead cell with 3 living neighbors comes alive, a "birth."
BIRTH=3
#	4) All other cases result in a dead cell for the next generation
################################################################

startfile=gen0	# Read the starting generation from the file "gen0"
		# Default, if no other file specified when invoking script.
if [ -n $1 ]
then
	startfile="$1"
fi

###################################################################
# Abort script if start file not specified
# and default file "gen0" not present

E_NOSTARTFILE=86

if [[ ! -e gen0 ]]
then
	echo "Startfile \" $startfile \" missing!"
	exit $E_NONSTARTFILE
fi

##################################################################

ALIVE1=.
DEAD1=_
	# Represent living and dead cells in the start-up file

#---------------------------------------------------------------
# This script uses a 10 x 10 grid (may be increases, 
# but a large grid will slow down execution).
ROWS=10
COLS=10
# Change above two variables to match desired grid size.
# ----------------------------------------------------------------

GENERATIONS=10 	# How many generations to cycle through
		# Adjust this upwards
		# if you have time on your hands

NON_ALIVE=85	# Exit status on premature bailout
		# if no cells life alive
		# Pause between generations

DELAY=2
TRUE=0
FALSE=1
ALIVE=0
DEAD=1

avar=		# Global; hods current generation
generation=0 	# Initialize generation count.

# ========================================================

let "cells = $ROWS * $COLS" #How many cells

# Arrays containing "cells."
declare -a initial
declare -a current

display(){
alive=0		#How many cells alive at any given time.
		# Initially zero

declare -a arr
arr=$(echo "$1") # Convert passed arg to array

element_count=${#arr[*]}

local i
local rowcheck

for (( i=0; i< $element_count; i++))
do
	# Insert newline at end of each row
	let " rowcheck = $i % COLS"
	if [ "$rowcheck" -eq 0 ]
	then
		echo			# Newline
		echo -n "	"	# Indent
	fi

	cell=${arr[i]}

	if [ "$cell" = "." ]
	then
		let " alive += 1"
	fi

	echo -n "$cell" | sed -e 's/_/ /g'
	# Print out array, changing underscors to spaces

done

return
}

IsValid()		# Test if cell coordinate valid
{

	if [ -z $1 -o -z $2 ]		# -o logic OR -a logic AND
	then
		return $FALSE
	fi

local row 
local lower_limit=0		# Disallow negative coordinate
local upper_limit
local left
local right

let "upper_limit = $ROWS * $COLS -1"  # Total number of cells

if [ $1 -lt $lower_limit -o $1 -gt $upper_limit ]
then
	return $FALSE
fi

row=$2
let "left = $row * $COLS"	# Left limit
let " right = $left + $COLS -1" # Right limit

if [ $1 -lt $left -o $1 -gt $right ]
then 
	return $FALSE		# Beyond row boundary
fi

return $TRUE
}

IsAlive()		# Test whether cell is alive
{			# Takes array, cell number, and state
			# of cell as arguments
			# Get alive cell count in neighborhood
	GetCount "$1" $2
	local nhbd=$?

	if [ $nhbd -eq $BIRTH ]
	then
		return $ALIVE
	fi

	if [ "$3" = "." -a "$nhbd -eq $SURVIVE" ]
	then		#Alive only if previously alive
		return $ALIVE
	fi

	return $DEAD
}

GetCount()
# Count live cells in passed cell's' neighborhood
# Two arguments needed
# $1) variable holding array
# $2) cell number
{

	local cell_number=$2
	local array
	local top
	local center
	local bottom
	local rr
	local row
	local i
	local t_top
	local t_cen
	local t_bot
	local count=0
	local ROW_NHBD=3

	array=( `echo "$1"` )

	let " top = $cell_number - $COLS -1" # Set up cell neighborhood
	let "center = $cell_number -1"
	let "bottom = $cell_number + $COLS -1"
	let "rr = $cell_number / $COLS"

	for (( i=0; i<$ROW_NHBD; i++))
	do
		let "t_top = $top + $i"
		let "t_cen = $center + $i"
		let "t_bot = $bottom + $i"

		let "row = $rr"
		IsValid $t_cen $row
	if [ $? -eq $TRUE ]
	then
		if [ ${array[$t_cen]} = "$ALIVE1" ] # Is it alive
		then
			let "count += 1 "
		fi
	fi

	let " row = $rr -1 "		# Count top row.
	IsValid $t_top $row
	if [ $? -eq $TRUE ]
	then
		if [ ${array[$t_top]} = $ALIVE1 ]
		then
			let " count += 1"
		fi
	fi

	let " row = $rr + 1"	# Count bottom row
	IsValid $t_bot $row
	if [ $? -eq $TRUE ]
	then
		if [ ${array[$t_bot]} = $ALVIE1 ]
		then
			let " count +=1 "
		fi
	fi

	done

	if [ ${array[$cell_number]} = $ALIVE1 ]
	then
		let "count -= 1"	# Nake sure value of tested cell
	fi				# is not vounted

	return $count
}


next_gen()
{

local array
local i=0

array=( `echo "$1"` ) 		# Convert passed arg to array

while [ $i -lt $cells ]	
do
	IsAlive $1 $i ${array[$i]} 	# Is the cell alive
	if [ $? -eq $ALIVE ]
	then
		array[$i]=.
	else
		array[$i]="_"
	fi
	let "i += 1"
done

# Set variable to pass as parameter to display function
avar=`echo ${array[@]}`
display "$avar"
echo; echo
echo " Generation $generation - $alive alive"

if [ $alive -eq 0 ]
then
	echo
	echo " Premature exit: no more cells alive!"
	exit $NONE_ALIVE
fi
}

# =========================================================

# main ()
#{

# Load initial array with contents of startup file.
initial=( `cat "$startfile" | sed -e '/#/d' | tr -d '\n'| sed -e 's/\./\. /g' -e 's/_/_ /g'` )
# Remove linefeeds and insert space between elements

clear

echo
setterm -reverse on
echo "====================="
setterm -reverse off
echo "	$GENERATIONS generations"
echo "		     of"
echo "\"Life in the Slow Lane\""
setterm -reverse on
echo "====================="
setterm -reverse off

sleep $DELAY

# ---------Desplay first generation--------
Gen0=`echo ${initial[@]}`
display "$Gen0"
echo;echo
echo "Generation $generation - $alive alive"
sleep $DELAY
#-------------------------------------------

let "generation +=1" # Bump generation count.
echo

#---------------Display second generation.--
Cur=`echo ${initial[@]}`
next_gen "$Cur"
sleep $DELAY
#--------------------------------------------

let "generation += 1"

#---------Main loop for displaying subsequent genreations--
while [ $generation -le "$GENERATIONS" ]
do
	Cur=$avar
	next_gen $Cur
	let "generation += 1 "
	sleep $DELAY
done

echo

#}

exit 0 # CEOF:EOF
