#!/bin/bash
# primes.sh: Generate prime numbers, without using arrrays
# Script by Stephane Chazelas

# This does *not* use the classic "Sieve of Eratoshenes" algorithm

LIMIT=1000	# Primes, 2 ... 1000

Primes()
{
	(( n = $1 + 1))
	shift
	# echo "_n=$n i=$i_"

	if (( n == LIMIT ))
	then
		echo $*
		return
	fi

	for i; do				# "i" set to "#@", previous value of $n
		# echo "-n=$n i=$i-"
		(( i * i > n )) && break  # optimization
		(( n % i )) && continue   # Sift out non-primes using modulo operator
		Primes $n $@		# Recursion inside loop
		return
	done

	Primes $n $@ $n
								# Recursion outside loop
						# Successively accumulate positional parameters
						# "#@" is the accumulating list of primes
}

Primes 1

exit $?


