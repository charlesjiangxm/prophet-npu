#!/bin/tcsh

# sourceme: set global env parameters
source ../ut/export.csh

# generate a temporal filelist for synthesis
envsubst < ${CODE_BASE_PATH}/filelist/c906_core_asic.fl > ${CODE_BASE_PATH}/filelist/c906_core_asic.tmp.fl
grep -v '/sram/' ${CODE_BASE_PATH}/filelist/c906_core_asic.tmp.fl > ${CODE_BASE_PATH}/filelist/c906_core_asic.syn.fl

# run dc
echo "running dc synthesis, the log is in dc.log"
dc_shell -f dc.tcl |& tee -i dc.log

# remove tmp file
rm -f ${CODE_BASE_PATH}/filelist/c906_core_asic.*.fl

