#!/bin/bash
# a word game
# qky.sh
# Author: Mendel Cooper

WLIST=/usr/share/dict/word.list

NONCONS=0
CONS=1
SUCCESS=0
NG=1
FAILURE=''
NULL=0
MINWLEN=3
MAXCAT=5
PENALTY=200
total=
E_DUP=70 # Word not constructable from letter set.
# Constructable.
TIMEOUT=10 # Time for word input.
NVLET=10
VULET=13 # 10 letters for non-vulnerable.
# Duplicate word error.
declare -a Words
declare -a Status
declare -a Score=( 0 0 0 0 0 0 0 0 0 0 0 )




letters=(a n s r t m l k p r b c i d s i d z e w u e t f
e y e r e f e g t g h h i t r s c i t i d i j a t a o l a
m n a n o v n w o s e l n o s p a q e e r a b r s a o d s
t g t i t l u e u v n e o x y m r k )
# Letter distribution table shamelessly borrowed from "Wordy" game,
#+ ca. 1992, written by a certain fine fellow named Mendel Cooper.
declare -a LS
numelements=${#letters[@]}
randseed="$1"
instructions ()
{
clear
echo "Welcome to QUACKEY, the anagramming word construction game."; echo
echo -n "Do you need instructions? (y/n) "; read ans
if [ "$ans" = "y" -o "$ans" = "Y" ]; then
clear
echo -e '\E[31;47m'
cat <<INSTRUCTION1
# Red foreground. '\E[34;47m' for blue.
QUACKEY is a variant of Perquackey [TM].
The rules are the same, but the scoring is simplified
and plurals of previously played words are allowed.
"Vulnerable" play is not yet implemented,
but it is otherwise feature-complete.
As the game begins, the player gets 10 letters.
The object is to construct valid dictionary words
of at least 3-letter length from the letterset.
Each word-length category
-- 3-letter, 4-letter, 5-letter, ... --
fills up with the fifth word entered,
and no further words in that category are accepted.
The penalty for too-short (two-letter), duplicate, unconstructable,
and invalid (not in dictionary) words is -200. The same penalty applies
to attempts to enter a word in a filled-up category.
INSTRUCTION1
echo -n "Hit ENTER for next page of instructions. "; read az1
cat <<INSTRUCTION2
The
The
The
The
The
The
The
The
The
scoring mostly corresponds to classic Perquackey:
first 3-letter word scores
60, plus
10 for each
first 4-letter word scores
120, plus
20 for each
first 5-letter word scores
200, plus
50 for each
first 6-letter word scores
300, plus 100 for each
first 7-letter word scores
500, plus 150 for each
first 8-letter word scores
750, plus 250 for each
first 9-letter word scores 1000, plus 500 for each
first 10-letter word scores 2000, plus 2000 for each
additional
additional
additional
additional
additional
additional
additional
additional
one.
one.
one.
one.
one.
one.
one.
one.
Category completion bonuses are:
3-letter words
100
4-letter words
200

# --------------------s 
instructions
seed_random
get_letset
play
end_of_game
#---------------------#

exit $?
