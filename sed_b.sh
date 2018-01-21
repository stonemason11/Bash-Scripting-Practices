#!/bin/bash
# this is script example from
# www.grymoire.com/Unix/Sed.html#uh-58

sed -n ' # no printing
# if an empty line, chech the paragraph
/^$/ b para
# else add it to the hold buffer
H
# at end of file, check paragraph
$ b para
# This is where a paragraph is checed for the pattern
:para
# return the entire paragraph
# into the pattern space
x
# look for the pattern, if there - print
/'$1'/ p
'



