#!/bin/bash

E_BADARGS=85

if [ -z $1 ]
then
	echo "Usage:`basename $0` filename"
	exit $E_BADARGS
fi

Username=
pword=/home/

#File containing encrypted password

Filename=`basename $1`

Server='XXX'
Directory="YYY"

Password=`cruft <$pword` # Decrypt password
ftp -n $Server <<End-of-Session
user $Username $Password
binary
bell
cd $Directory
put $Filename
bye
End-of-Session

#-n option ot "ftp" disables auto-logon
# Note that "bell" rings 'bell' after each file transfer

exit 0
