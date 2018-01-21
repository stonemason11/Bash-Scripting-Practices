#!/bin/bash

: <<'LIMITSTRING'

#----------------------------------------------------------------
# pseudo hash based on indirect parameter expansion
# API: access through functions:
#
# create the hash:
#
#
newhash Lovers
#
# add entries (note single quotes for spaces)
#
#
addhash Lovers Tristan Isolde
#
addhash Lovers 'Romeo Montague' 'Juliet Capulet'
#
# access value by key
#
#
gethash Lovers Tristan
----> Isolde
#
# show all keys
#
#
keyshash Lovers
----> 'Tristan' 'Romeo Montague'
#
#
# Convention: instead of perls' foo{bar} = boing' syntax,
# use
#
'_foo_bar=boing' (two underscores, no spaces)
#
# 1) store key
in _NAME_keys[]
# 2) store value in _NAME_values[] using the same integer index
# The integer index for the last entry is _NAME_ptr
#
# NOTE: No error or sanity checks, just bare bones.

LIMITSTRING


function _inihash()
{
	# private function
	# call at the beginning of each procedure
	# defines: _key _values _ptr

	# Usage: _inihash Name
	local name=$1
	_keys=_${name}_keys
	_values=_${name}_values
	_ptr=_${name}_ptr	# this is the pointer to the hash
}

function newhash()
{
	# Usage: newhash Name
	# Name shoud not contain spaces or dots
	# Actually: it must be a legal name for a Bash variable
	# We rely on Bash automatically recognising arrays
	local name=$1
	local _keys _value _ptr
	_inihash ${name}
	eval ${_ptr}=0
}

addhash ()
{
	# Usage: addhash Name KEY 'Value with spaces'
	# arguments with spaces need to be quoted with single quotes
	
	local name=$1 k="$2" v="$3"
	local _keys _values _ptr
	_inihash ${name}

	# echo "DEBUG(addhash): ${_ptr}=${!_ptr}"
	eval let ${_ptr}=${_ptr}+1
	eval "$_keys[${!_ptr}]=\"${k}\""
	eval "$_values[${!_ptr}]=\"${v}\""
}

function gethash()
{
	# Usage: gethash Name KEY
	# Returns boing
	# Err=0 if entry found, 1 otherwise
	# That's not a proper hash --
	#+ we simply linearly search through the keys

	local name=$1 key="$2"
	local _keys _values _ptr
	local k v i found h
	_inihash ${name}

	# _ptr holds the highest index in the hash
	found=0

	for i in $(seq 1 ${!_ptr}); do
		h="\${${_keys}[${i}]}"	
		eval k=${h}
		if [ "${k}" = "${key}" ]; then found=1; break; fi
	done

	[ ${found} = 0 ] && return 1;
	# else: i is the index that matches the key
	h="\${${_values}[${i}]}"
	eval echo "${h}"
	return 0
}

function keyhash()
{
	# Usage: keyhash NAME
	# Returns list of all keys defined for hash name
	local name=$1 key="$2"
	local _kets _values _ptr
	local k i h
	_inihash $name
	
	# _ptr holds the highest index in the hash
	for i in `seq 1 ${!_ptr}`;do
		h="\${${_keys}[${i}]}"	
		eval k=${h}
		echo -n "'${k}'"
	done
}
	
#-----------------------------------------------------
# test the hashs

newhash Lovers
addhash Lovers Tristan Isolde
addhash Lovers 'Romeo Montague' 'Juliet Capulet'

# output results
echo
gethash Lovers Tristan
echo
keyhash Lovers		# 'Tristan' 'Romeo Montague'
echo;echo

exit 0

# Exercise
#---------

# Add error checks to the functions
