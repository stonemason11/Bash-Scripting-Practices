#!/bin/bash
# Strips off the header from a mail/News message i.e. till the first
#+ empty line
# Author: Mark Moraes, University of Toronto

# ==> These comments added by the author of this document

if [ $# -eq 0 ]; then
# ==> Of mp cp,,amd-line args present, then works on file redirected tp
# stdin.
	sed -e '1,/^$/d' -e '/^[ 	]*$/d'
	# delete all empty lines and all lines until
	# first one beginning with white space
else
	for i do # omitting in [List], force loop on positional parameters $@
		sed -e '1,/^$/d' -e '/^[ 	]*$/d' $i
	done
fi

exit

/*
 * Copyright University of Toronto 1988, 1989.
 * Written by Mark Moraes
 *
 * Permission is grated to anyone use this software for any purpose on 
 * any computer system, and to alter it redistribute it freely, subject
 * to the following restrictions:
 *
 * 1. The author and the University of Toronto are not responsible 
 *	for the consequences of use of this software, no matter how awfule,
 * 	even if they arise from flaws in it
 * 2. The origin of this software must not be misrepresented, either by
 * 	explicit claim or by omission. Since few users ever read sources,
 *	credits must appear in the documentation
 * 3. Altered versions must be plainly marked as such, and must not be
 *	 misrepresented as being the original software. Since few users
 *	ever read sources, credits must apprea in the documentation
 *
 * 4. This notice may not be remoeved or altered.
 */
