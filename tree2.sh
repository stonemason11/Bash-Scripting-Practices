#!/bin/bash
# tree2.sh

# Recursive file/dirsize checking script by Patsie

# this script builds a list of fies/directories and their size (du -akx_
# and processes this list to a human readable tree shape
# The 'du -akx' is only as good as the permissions the owner has
# So preferably run as root* to get the best results, or use only on
# directories for which you have read permissions. Anything you can't 
# read is not in the list


TOP=5			# Top 5 biggest (sub)directories
MAXRECURS=5		# Max 5 subdir/recursions deep
E_BL=80			# Blank line already returned
E_DIR=81		#Directory not specified

############Don't change anything below this line##########

PID=$$			# Our own process ID
SELF=`basename $0`
TMP="/tmp/${SELF}.${PID}.tmp" # Temporary 'du' result

# Convert number to dotted thousand

function dot()
{
	echo "		$*" |
	sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta' |
	tail -c 12;
	# : label, \(\) group for latter reference \1 \2
	# \{N\}: number of appearances
}

# test this 
# dot 123456778

# Usage: tree <recursion> <indent prefix> <min size> <directory>
function tree ()
{
	recurs="$1"	# How deep nested are we?
	prefix="$2"	# What do we display before file/dirname?
	minisize="$3"	# What is the minimum file/dirsize?
	dirname="$4"	# Which directory are we checking

# Get ($TOP) biggest subdirs/subfiles/from TMP file
	LIST=`egrep "[[:space:]]${dirname}/[^/]*$" "$TMP" |
	awk '{if($1>'$minisize') print;}' | sort -nr | head -$TOP`
	[ -z "$LIST" ] && return # Empty list, then go back.

	cnt=0
	num=`echo "$LIST" | wc -l` # How many entries in the list.

	## Main loop
	echo "$LIST" | while read size name; do
	 ((cnt+=1))			# Count entry number.
	 bname=`basename "$name"`	# We only need a basename of the entry
	[ -d "$name" ] && bname="$bname/"
					# If it is a directory, append a slash
	echo "`dot $size`$prefix+-$bname"
					# Display the result
	# Call ourself recursively if its a directory
	# and we are not nested too deep ($MAXRECURS)
	# The recursion goes up: $((recurs+1))
	# The prefix gets a space if its the last entry
	# or a pipe if there are more entries.
	# The minmum file/dirsize becomes
	# a tenth of his parent: $((size/10).
	# Last argument is the full directory name to check
	if [ -d "$name" -a $recurs -lt $MAXRECURS ]; then
		[ $cnt -lt $num ] \
		|| (tree $((recurs+1)) "$prefix " $((size/10)) "$name")\
		&& (tree $((recurs+1)) "$prefix |" $((size/10)) "$name")
	fi
done
	[ $? -eq 0 ] && echo "		$prefix"
	# Every time we jump back add a 'blank' line
	return $E_BL
	# We return 80 to tell we added a blank line already
}

### Main Program ###
rootdir="$@"
[ -d "$rootdir" ] ||
	{ echo "$SELF: Usage: $SELF <directory>" >&2; exit $E_DIR;}
	# We should be called with a directory name

echo "Building inventory list, please wait ...."
	# Show " please wait message.
du -akx "$rootdir" 1> "$TMP" 2>/dev/null
	# Build a temporary list of all files/dirs and their sizes
	# du -a: all files, -k : blocksize=1k, -x: skip dirs on different file system
size=`tail -l "$TMP" | awk '{print $1}'`
	# What is our rootdirectory's size?
echo "`dot $size` $rootdir"
	# Display root directory's entry.
tree 0 "" 0 "$rootdir"
	#Display the tree below our rootdirecotry

rm "$TMP" 2> /dev/null
	# Clean up TMP file.
exit $?
