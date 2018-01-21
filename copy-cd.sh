#!/bin/bash
# copy-cd.sh: copying a data CD

CDROM=/dev/cdrom
OF=/home/wsun3/cdimage.iso
BLOCKSIZE=2048
#SPEED=10
#DEVICE=/dev/cdrom
DEVICE="1,0,0"

echo; echo "Insert source CD, but do *not* mount it"
echo "Press ENTER when ready"
read ready

echo; echo "Copying the source CD to $OF"
echo "This may take a while. Please be patient."

dd if=$CDROM of=$OF bs=$BLOCKSIZE # Raw device copy

echo;echo " Remove data CD"
echo "Insert blank CDR."
echo "Press Enter when ready"
read ready

echo "Copying $OF to CDR."

# cdrecord -v -isosize speed=$SPEED dev=$DEVICE $OF #old version
wodim -v -isosize dev=$DEVICE $OF
# Uses Joerg Schlling's "cdrecord" package

echo; echo "Done copying $OF to CDR on device $CDROM."

echo "Do you want to erase the image file (y/n)?" 
read answer

case "$answer" in
[yY]) rm -f $OF
echo "$OF erased"
;;
*) echo "$OF not erased.";;
esac

exit 0
