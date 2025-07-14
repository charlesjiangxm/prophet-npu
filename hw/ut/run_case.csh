#!/bin/tcsh

source export.sh

rm -rf work
cp -r ../../sw/scripts/hhb_out work
make compile
