#/*Copyright 2020-2021 T-Head Semiconductor Co., Ltd.
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#*/
#*/
#*/
CPU_ARCH_FLAG_0 := c906fd
CASE_LIST := \
      ISA_THEAD \
      ISA_INT \
      ISA_LS \
      ISA_FP \
      coremark \
      MMU \
      interrupt \
      exception \
      debug \
      csr \
      cache \
      hello \
      wr_reg \
      uart_print \


ISA_THEAD_build:
	@cp ./tests/cases/ISA/ISA_THEAD/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=ISA_THEAD FILE=C906_THEAD_ISA_EXTENSIO


ISA_INT_build:
	@cp ./tests/cases/ISA/ISA_INT/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=ISA_INT FILE=C906_INT_SMOKE


ISA_LS_build:
	@cp ./tests/cases/ISA/ISA_LS/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=ISA_LS FILE=C906_LSU_SMOKE


ISA_FP_build:
	@cp ./tests/cases/ISA/ISA_FP/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=ISA_FP FILE=C906_FPU_SMOKE


coremark_build:
	@cp ./tests/cases/coremark/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cp ./tests/lib/clib/* ./work
	@cp ./tests/lib/newlib_wrap/* ./work
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=coremark FILE=core_main


MMU_build:
	@cp ./tests/cases/MMU/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=MMU FILE=C906_mmu_basic


interrupt_build:
	@cp ./tests/cases/interrupt/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=interrupt FILE=C906_plic_int_smoke




exception_build:
	@cp ./tests/cases/exception/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=exception FILE=C906_Exception


debug_build:
	@cp ./tests/cases/debug/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=debug FILE=C906_DEBUG_PATTERN


csr_build:
	@cp ./tests/cases/csr/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=csr FILE=C906_CSR_OPERATION


cache_build:
	@cp ./tests/cases/cache/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=cache FILE=C906_IDCACHE_OPER

hello_build:
	@cp ./tests/cases/hello/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cp ./tests/lib/clib/* ./work
	@cp ./tests/lib/newlib_wrap/* ./work
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=hello FILE=hello

wr_reg_build:
	@cp ./tests/cases/wr_reg/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=wr_reg FILE=wr_reg

uart_print_build:
	@cp ./tests/cases/uart_print/* ./work
	@find ./tests/lib/ -maxdepth 1 -type f -exec cp {} ./work/ \; 
	@cp ./tests/lib/clib/* ./work
	@cp ./tests/lib/newlib_wrap/* ./work
	@cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c906fd  ENDIAN_MODE=little-endian CASENAME=uart_print FILE=uart_print


# Adjust verilog filelist for *.v case...
ifeq ($(CASE), debug)
SIM_FILELIST := ../tests/cases/debug/JTAG_DRV.vh ../tests/cases/debug/C906_DEBUG_PATTERN.v
endif


define newline


endef


