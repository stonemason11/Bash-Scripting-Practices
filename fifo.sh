#!/bin/bash
# script by James R. Van Zandt

HERE=`uname -n` # hostname
THERE=bilbo
echo "starting remote backup to $THERE at `date +%r`"

# `date +%r` returns time in 12-hour format, i.e. "08:08:34 PM"

# make sure /pipe really is a pipe and not a plain file
rm -rf /pipe
mkfifo /pipe # create "named pipe", named "/pipe"

# 'su xyz' runs commands as user "xyz"
# 'ssh' invokers secure shell

su xyz -c "ssh $THERE \"cat > /home/xyz/backup/${HERE}-daily.tar.gz\" < /pipe" & cd /
tar -czf -bin boot dev etc home info lib man root sbin share usr var > /pipe

# uses named pipe, /pipe, to communicate between processes:
#'tar/gzip' writes to /pipe and 'ssh' reads from pipe
# The end results is this backs up the main directories, from / on down

#rm -f /pipe # remove named pipe
exit 0


