#!/bin/bash
# progress-bar.sh

# Author: Dotan Barak


BAR_WIDTH=50
BAR_CHAR_START="["
BAR_CHAR_END="]"
BAR_CHAR_EMPTY="."
BAR_CHAR_FULL="="
BRACKET_CHARS=2
LIMIT=100

print_progress_bar()
{
	# Calculate how many characters will be full
	let "full_limit = ((($LIMIT-$BRACKET_CHARS) * $2) / $1)"
	#Calculate how many characters will be empty
	let "empty_limit = ($LIMIT - $BRACKET_CHARS) - ${full_limit}"


	# Prepare the bar
	bar_line="${BAR_CHAR_START}"
	for (( j=0; j<full_limit; j++));do
		bar_line="${bar_line}${BAR_CHAR_FULL}"
	done
	for (( j=0; j<empty_limit; j++ )); do
		bar_line="${bar_line}${BAR_CHAR_EMPTY}"
	done

	bar_line="${bar_line}${BAR_CHAR_END}"
	percentage=`echo "scale=3; $2 / $1 * 100 " | bc`
	printf "%f%% %s" ${percentage} ${bar_line}
}

MAX_PERCENT=50
for ((i=0; i<=MAX_PERCENT; i++)); do
	sleep .5
	print_progress_bar ${MAX_PERCENT} ${i}
	echo -en "\r"
done

echo ""

exit
