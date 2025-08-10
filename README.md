# NPU-HKUST

SIMD-based NPU core with vector and matrix instruction support. The hardware tree integrates a RISC-V C906 core, AXI interconnect, APB peripherals, and a minimal SoC wrapper and testbench to simulate and run sample workloads (CoreMark, hello, vector add, etc.).

## Repository layout

- `hw/`
	- `rtl/`
		- `c906_core/` – OpenC906 CPU core and blocks (BIU, IFU/LSU/MMU, PLIC/CLINT, TDT debug, SoC wrapper)
		- `peripheral/` – APB/AXI peripherals
		- `soc/` – Simple SoC top with AXI interconnect and clock/reset
	- `ut/` – Simulation environment (VCS-based) with testbench, filelists, and cases
		- `tb/` – Top-level testbench
		- `filelists/` – RTL filelists for comp/sim
		- `tests/` – Example cases and regression harness
		- `work*` – Prebuilt/example application artifacts (coremark, hello, vec_add)
- `sw/` – Utilities, scripts, and example software build helpers
- `LICENSE` – Project license (Apache-2.0)

## Quick start (simulation)

Requires a supported simulator (Makefile is set up for Synopsys VCS) and a RISC-V toolchain for building C test cases when needed.

1) Compile RTL + testbench

```bash
cd hw/ut
make compile
```

2) List available cases

```bash
make showcase
```

3) Run a case (replace <case> with one printed by showcase)

```bash
make runcase CASE=<case>
```

Notes
- Wave dump can be toggled via `DUMP=on`.
- To run all cases: `make regress`.

## AXI/Debug at a glance

- AXI4 master (128-bit data, 40-bit address) exported from the BIU: AW/W/B for writes and AR/R for reads.
- APB3/4 for PLIC/CLINT and the RISC-V Debug Module Interface (DMI). System Bus Access (SBA) from debug uses a separate AXI master port `tdt_dm_pad_*`.

## License

Apache License 2.0. See `LICENSE` for full text. For source files, you may add SPDX headers like:

```verilog
// SPDX-License-Identifier: Apache-2.0
```

## Acknowledgements

This project incorporates components derived from T-Head OpenC906 under the Apache-2.0 license.

