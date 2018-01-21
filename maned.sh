#!/bin/bash
# maned.sh
# A rudimentary man page editor

# Version: 0.1
# Author: Mendel Cooper
# License: GPL3

savefile=
E_NOINPUT=90

# ==========markup tags==============#
TopHeader=".TH"
NameHeader=".SH NAME"
SyntaxHeader=".SH SYNTAX"
SynopsisHeader=".SH SYNOPSIS"
InstallationHeader=".SH INSTALLATION"
DescHeader=".SH DESCRIPTION"
OptHeader=".SH OPTIONS"
FilesHeader=".SH FILES"
EnvHeader=".SH ENVIRONMENT"
AuthHeader=".SH AUTHOR"
BugsHeader=".SH BUGS"
SeeAlsoHeader=".SH SEE ALSO"
BOLD=".B"
# Add more tags, as needed.
# See groff docs for markup meanings.
# ==================================== #

function start(){
clear
echo "ManEd"	# Clear screen
echo "-----"
echo
echo "Simple man page creator"
echo "Author: Mendel Cooper"
echo "License:GPL3"
echo; echo; echo
}

function progname(){
  echo -n "Program name?"
  read name	# save user input in variable
  
  echo -n "Manoage section? [Hit RETURN for default(\"1\" ])"
  read section
  if [ -z "$section" ]
  then 
	section=1
  fi
  
  if [ -n "$name" ]
  then
	savefile=""$name"."$section""  # Filename suffix=section
	echo -n $1 >> $savefile
	name1=$(echo "$name" tr a-z A-z)
	
	echo -n $name1 >>$savefile
  else
	echo "Error! No input."
	exit $E_NOINPUT
  fi

echo -n " \"$section\"">>$savefile
# Append, always append.
echo
echo -n "Version? "
read ver
echo -n " \"Version $ver \"">>$savefile
>>$savefile
echo
read sdesc
echo
echo
echo -n "Short description [0 - 5 words]? "
echo "$NameHeader">>$savefile
echo ""$BOLD" "$name"">>$savefile
echo "\- "$sdesc"">>$savefile
}


fill_in ()
{ # This function more or less copied from "pad.sh" script.
echo -n "$2? "
# Get user input.
read var
# May paste (a single line only!) to fill in field.
if [ -n "$var" ]
then
echo "$1 " >>$savefile
echo -n "$var" >>$savefile
else
# Don't append empty field to file.
return $E_NOINPUT # Not critical here.
fi

echo >>$savefile
}
end ()
{
clear
echo -n "Would you like to view the saved man page (y/n)? "
read ans
if [ "$ans" = "n" -o "$ans" = "N" ]; then exit; fi
exec less "$savefile" # Exit script and hand off control to "less" ...
#+ ... which formats for viewing man page source.
}

# ---------------------------------------- #
start
progname "$TopHeader"
fill_in "$SynopsisHeader" "Synopsis"
fill_in "$DescHeader" "Long description"
# May paste in *single line* of text.
fill_in "$OptHeader" "Options"
fill_in "$FilesHeader" "Files"
fill_in "$AuthHeader" "Author"
fill_in "$BugsHeader" "Bugs"
fill_in "$SeeAlsoHeader" "See also"
# fill_in "$OtherHeader" ... as necessary.
end

: <<qwerty
# ... exit not needed.
# ---------------------------------------- #
#
#+
#
#+
#+ Note that the generated man page will usually
require manual fine-tuning with a text editor.
However, it's a distinct improvement upon
writing man source from scratch
or even editing a blank man page template.
#
#+
#
#
#
#+
#+
# The main deficiency of the script is that it permits
pasting only a single text line into the input fields.
This may be a long, cobbled-together line, which groff
will automatically wrap and hyphenate.
However, if you want multiple (newline-separated) paragraphs,
these must be inserted by manual text editing on the
script-generated man page.
Exercise (difficult): Fix this!
#
#+
#+
#+ This script is not nearly as elaborate as the
full-featured "manedit" package
http://freshmeat.net/projects/manedit/
but it's much easier to use.
qwerty

