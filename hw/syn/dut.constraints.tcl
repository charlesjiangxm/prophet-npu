################################################################################
# Clocks
################################################################################
# Core clock: pll_core_cpuclk @ 500 MHz (2.0 ns)
create_clock -name pll_core_cpuclk -period 0.7 [get_ports pll_core_cpuclk]

# APB/Debug clock: sys_apb_clk @ 100 MHz (10.0 ns)
create_clock -name sys_apb_clk -period 10.0 [get_ports sys_apb_clk]

# The two clocks are asynchronous to avoid CDC timing across domains
set_clock_groups -asynchronous -group {pll_core_cpuclk} -group {sys_apb_clk}

################################################################################
# IO Delays (generic budgeting for synthesis)
################################################################################
set clk_ports [get_ports {pll_core_cpuclk sys_apb_clk}]
set rst_ports [get_ports {pad_cpu_rst_b sys_apb_rst_b}]

set core_inputs  [remove_from_collection [all_inputs]  $clk_ports]
set core_inputs  [remove_from_collection $core_inputs  $rst_ports]
set core_outputs [all_outputs]

# Apply modest default timing budgets relative to the core clock
set_input_delay  -max 0.1 -clock pll_core_cpuclk $core_inputs
set_input_delay  -min 0.1 -clock pll_core_cpuclk $core_inputs
set_output_delay -max 0.1 -clock pll_core_cpuclk $core_outputs
set_output_delay -min 0.1 -clock pll_core_cpuclk $core_outputs

################################################################################
# Resets: treat as ideal networks and remove from timing
################################################################################
set_ideal_network      $rst_ports
set_dont_touch_network $rst_ports
set_false_path -from $rst_ports

################################################################################
# Environment attributes
################################################################################
# Output load model
set_load 1.0 [all_outputs]

# Input transition time on all inputs except clock/reset
set non_cr_inputs [remove_from_collection [all_inputs] $clk_ports]
set non_cr_inputs [remove_from_collection $non_cr_inputs $rst_ports]
set_input_transition 0.1 $non_cr_inputs
