# PROPHET-NPU

SIMD-based NPU core with vector and matrix instruction support. The hardware tree integrates a RISC-V vector core (C906) and a matrix core (NVDLA).  

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

## License

Apache License 2.0. See `LICENSE` for full text. For source files, you may add SPDX headers like:

## Acknowledgements

This project incorporates components derived from T-Head OpenC906 and Nvidia NVDLA.  

