#!/bin/bash

# sourceme: set global env parameters
eval "$(tcsh -c 'source ../ut/export.csh; env')"

# run dc shell
if [[ $1 == "debug" ]]; then
    dc_shell -gui
elif [[ $1 == "syn" ]]; then
    dc_shell -f dc.tcl | tee -i dc.log
fi