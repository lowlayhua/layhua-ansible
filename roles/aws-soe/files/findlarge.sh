#!/bin/bash
# if nothing is passed to the script, show usage and exit
##
##  to find files more than G size
##  usage  :   sh findlarge.sh /
##
##
[[ -n "$1" ]] || { echo "Usage: findlarge [PATHNAME]"; exit 0 ; }
# simple using find, $1 is the first variable passed to the script
find $1 -type f -size +1000M -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'

