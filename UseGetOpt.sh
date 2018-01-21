#!/bin/bash
# UseGetOpt.sh

# Author: Peggy Russell

UseGetOpt(){
  declare inputOptions
  declare -r E_OPTERR=85	# Readonly
  declare -r ScriptName=${0##*/} # Strip the longest match from begining
  declare -r ShortOpts="adf:hlt"
  declare -r LongOpts="aoption,debug,file:,help,log,test"
  
DoSomething(){
  echo "The function name is '${FUNCNAME}'"
  # Recall than $FUNCNAME is an internal variable
  #+ holding the name of the function it is in
}


  inputOptions=$(getopt -o "${ShortOpts}" --long "${LongOpts}" --name "${ScriptName}" -- "$@" ) 

  if [[ ($? -ne 0) || ($# -eq 0) ]]; then
    echo "Usage: ${ScriptName} [-dhlt] {OPTION...}"
    exit $E_OPTERR
  fi

  eval set -- "${inputOptions}"

  # Only for educational purposes. Can be removed
  # ----------------------------------------------
  echo "++ Test: Number of arguments: [$#]"
  echo '++ Test: Looping through "$@"'
  for a in "$@"; do
    echo "  ++[$a]"
  done
  #-----------------------------------------------

  while true; do
    case "${1}" in
    --aoption | -a) # Argument found
      echo "Option [$1]"
      ;;
    --debug | -d) echo "Option [$1] Debugging enabled";;
    --file | -f)
 		case $2 in 
 		"")  echo "Option [$1] Use default"
 			shift
		;;
		*) echo "Option [$1] Using input [$2]"
			shift
 		;;
		esac
	DoSomething
 	;;
    --log | -l)  echo "Option [$1] Logging enabled";;
    --test | -t) echo "Option [$1] Testing enabled";;
    --help | -h) echo "Option [$1] Desplay help"
			break
			;;
    --) echo "Option [$1] Dash Dash"; break ;;
    *) echo "Major internal error!"
	exit 8
	;;
  esac
echo "Number of arguments:[$#]"
shift
done

shift
}

echo "Test 1"
UseGetOpt -f myfile one "two three" four

echo "Test 2"
UseGetOpt -h

echo "Test 3"
UseGetOpt -adltf myfile anotherfile

echo; echo "Test 4 -Long Options"
UseGetOpt -aoption --debug --log --test --file myfile anotherfile

exit

