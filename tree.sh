#!/bin/bash
# tree.sh

# Written by Rick Boivie

search()
{
for dir in `echo *`		# without linebreaks
do
	if [ -d $dir ]; then
		zz=0			# Temp variable, keeping track of directory level
		while [ $zz != $1 ]
		do
			echo -n "|"

			zz=`expr $zz + 1`
		done


		if [ -L "$dir" ]; then 	# if directory is a symbolic link
			echo "+---$dir" `ls -l $dir | sed 's/^.*'$dir' //'`
			# disp horiz. connnector and list dir name, 
		# but delete date/time part of long listing
		else
			echo "+---$dir"
		
			numdirs=`expr $numdirs + 1`
			if cd "$dir"; then
				search `expr $1 + 1`
				cd ..
			fi
		fi
	fi
done
}

if [ $# != 0 ] ; then
	cd $1
fi

echo "Initial directory = `pwd`"
numdirs=0

search 0
echo "Total directories = $numdirs"

exit 0
