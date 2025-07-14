#!/bin/tcsh

source export.sh

rm -rf work
ln -s ../../sw/scripts/hhb_out work
make compile
