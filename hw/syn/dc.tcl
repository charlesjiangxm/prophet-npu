################################################################################
# Filename: dc.tcl
# Author: ZHU Jingyang
# Email: jzhuak@connect.ust.hk
# Affiliation: Hong Kong University of Science and Technology
# -------------------------------------------------------------------------------
# This is the template Design Compiler script for ELEC5160/EESM5020.
################################################################################
set WORK_ROOT $env(CODE_BASE_PATH)
set HDL_PATH ${WORK_ROOT}/c906_core
set TOP_MODULE_NAME openC906

# TSMC 28nm logic library
set DB_PATH /home/ic/tsmc28/logic/tcbn28hpcplusbwp12t40p140lvt_180a/AN61001_20180514/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn28hpcplusbwp12t40p140lvt_180a
set DB_NAME tcbn28hpcplusbwp12t40p140lvttt1v25c_ccs.db
set SRAM_LIBS "
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb1024x16m4swbaso_180a/NLDM/ts1n28hpcplvtb1024x16m4swbaso_180a_tt1v25c.db
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb1024x64m4swbaso_180a/NLDM/ts1n28hpcplvtb1024x64m4swbaso_180a_tt1v25c.db
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb128x8m4swbaso_180a/NLDM/ts1n28hpcplvtb128x8m4swbaso_180a_tt1v25c.db
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb2048x32m4swbaso_180a/NLDM/ts1n28hpcplvtb2048x32m4swbaso_180a_tt1v25c.db
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb256x59m4swbaso_180a/NLDM/ts1n28hpcplvtb256x59m4swbaso_180a_tt1v25c.db
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb64x58m4swbaso_180a/NLDM/ts1n28hpcplvtb64x58m4swbaso_180a_tt1v25c.db
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb64x88m4swbaso_180a/NLDM/ts1n28hpcplvtb64x88m4swbaso_180a_tt1v25c.db
/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/ts1n28hpcplvtb64x98m4swbaso_180a/NLDM/ts1n28hpcplvtb64x98m4swbaso_180a_tt1v25c.db
"

################################################################################
# Step 0: create directories for results and reports
################################################################################
file mkdir reports; # store area, timing, power reports
file mkdir results; # store design

################################################################################
# Step 1: library setup
################################################################################
# Update search_path
set_app_var search_path ". ${DB_PATH} ${HDL_PATH} $search_path"
foreach sram $SRAM_LIBS {
    set dir [file dirname $sram]
    lappend search_path $dir
}

# Set target and link libraries
set_app_var target_library "${DB_NAME}"
set_app_var link_library "* $target_library $SRAM_LIBS"

################################################################################
# Step 2: import design
################################################################################
define_design_lib WORK -path ./WORK
analyze -format verilog -vcs "-f ${WORK_ROOT}/filelist/c906_core_asic.syn.fl +libext+.v"

elaborate ${TOP_MODULE_NAME}; # top module name

# store the unmapped results
write -hierarchy -format ddc -output results/${TOP_MODULE_NAME}.unmapped.ddc

################################################################################
# Step 3: constrain your design
################################################################################
source dut.constraints.tcl

# Create default path groups
set ports_clock_root \
  [filter_collection [get_attribute [get_clocks] sources] object_class==port]
group_path -name REGOUT -to [all_outputs]
group_path -name REGIN -from [remove_from_collection [all_inputs] \
  ${ports_clock_root}]
group_path -name FEEDTHROUGH -from \
  [remove_from_collection [all_inputs] ${ports_clock_root}] -to [all_outputs]

# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants

# Check for design errors
check_design -summary
check_design > reports/${TOP_MODULE_NAME}.check_design.rpt

################################################################################
# Step 4: compile the design
################################################################################
compile_ultra

# Optional: keep hierarchy for debug
# compile_ultra -no_autoungroup

# High-effort area optimization
optimize_netlist -area

################################################################################
# Step 5: write out final design and reports
################################################################################
change_names -rules verilog -hierarchy

# Write out design
write -format verilog -hierarchy -output results/${TOP_MODULE_NAME}.mapped.v
write -format ddc -hierarchy -output results/${TOP_MODULE_NAME}.mapped.ddc
write_sdf results/${TOP_MODULE_NAME}.mapped.sdf
write_sdc -nosplit results/${TOP_MODULE_NAME}.mapped.sdc

# Generate reports
report_qor > reports/${TOP_MODULE_NAME}.mapped.qor.rpt
report_timing -transition_time -nets -attribute -nosplit \
  > reports/${TOP_MODULE_NAME}.mapped.timing.rpt
report_area -nosplit > reports/${TOP_MODULE_NAME}.mapped.area.rpt
report_power -nosplit > reports/${TOP_MODULE_NAME}.mapped.power.rpt

################################################################################
# Exit Design Compiler
################################################################################
exit
