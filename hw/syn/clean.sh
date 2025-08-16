#!/bin/bash

# enable extended globbing
shopt -s extglob  

# Remove everything except the listed files
rm -rf !(c906_syn.fl|clean.sh|cvrt_lib2db.sh|dc.tcl|dut.constraints.tcl|gen_sram.sh|run_dc.csh)
