#!/bin/tcsh

source export.csh

# remove the existing work directory
rm -rf work

# buildcase or cp already built case
# cp -r ../../sw/scripts/hhb_out work
mkdir work; make buildcase CASE=hello

# compile
make compile
