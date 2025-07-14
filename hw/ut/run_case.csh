#!/bin/tcsh

source export.csh

rm -rf work
cp -r ../../sw/scripts/hhb_out work
make compile
