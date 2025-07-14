# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

CC = riscv64-unknown-linux-gnu-gcc
AS = riscv64-unknown-linux-gnu-as
OBJDUMP = riscv64-unknown-linux-gnu-objdump
OBJCOPY = riscv64-unknown-linux-gnu-objcopy
CONVERT = ../../utils/Srec2vmem

INCLUDE += -I/usr/local/lib/python3.8/dist-packages/hhb/install_nn2/x86/include/ \
	-I/usr/local/lib/python3.8/dist-packages/tvm/dlpack/include/ \
	-I/usr/local/lib/python3.8/dist-packages/hhb/install_nn2/x86/include/shl_public/ \
	-I/usr/local/lib/python3.8/dist-packages/hhb/install_nn2/x86/include/csinn/ \
	-I/usr/local/lib/python3.8/dist-packages/tvm/include/ \
	-I \
	/usr/local/lib/python3.8/dist-packages/hhb/prebuilt/runtime/cmd_parse \
	-I.

LDFLAGS += -L/usr/local/lib/python3.8/dist-packages/hhb/install_nn2/c906/lib/ \
	-L/usr/local/lib/python3.8/dist-packages/hhb/prebuilt/decode/install/lib/rv \
	-L/usr/local/lib/python3.8/dist-packages/hhb/prebuilt/runtime/riscv_linux \
	

# Build regular Linux executable first, then convert for simulator
CFLAGS +=  -O2 -g -mabi=lp64d  -march=rv64imafdcxtheadc ${INCLUDE}
LDFLAGS += -Wl,--gc-sections -O2 -g -mabi=lp64d -lshl -fopenmp -static -lprebuilt_runtime -ljpeg -lpng -lz -lstdc++ -lm

# Set simulator-compatible entry point via linker script
# The entry point should be 0x10000000 to match hello.elf
LDFLAGS += -Wl,--entry=0x10000000 -Wl,--section-start=.text=0x10000000

# pat file for vcs simulation
INST_PAT = inst.pat
DATA_PAT = data.pat
FILE_PAT = case.pat

.PHONY: clean all

all: hhb_runtime_sim.pat hhb_runtime_sim.elf hhb_runtime_sim.obj hhb_runtime_sim.hex

main.o: main.c
	$(CC) $(CFLAGS) -c -o $@  $^

model.o: model.c
	$(CC) $(CFLAGS) -c -o $@  $^

io.o: io.c
	$(CC) $(CFLAGS) -c -o $@  $^

# Build regular Linux executable
hhb_runtime_sim.elf: main.o model.o io.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Object dump generation
hhb_runtime_sim.obj: hhb_runtime_sim.elf
	$(OBJDUMP) -S -Mnumeric $< > $@

# Hex files generation
INST_HEX = hhb_runtime_sim_inst.hex
DATA_HEX = hhb_runtime_sim_data.hex

hhb_runtime_sim.hex: hhb_runtime_sim.elf
	$(OBJCOPY) -O srec $< $(INST_HEX) -j .text* -j .rodata* -j .eh_frame*
	$(OBJCOPY) -O srec $< $(DATA_HEX) -j .data* -j .bss -j .COMMON
	$(OBJCOPY) -O srec $< $@

%.pat	: %.hex
	rm -f *.pat
	${CONVERT} ${INST_HEX} ${INST_PAT}
	${CONVERT} ${DATA_HEX} ${DATA_PAT}

clean:
	-rm *.pat *.o hhb_runtime_sim.elf hhb_runtime_sim.obj hhb_runtime_sim.hex hhb_runtime_sim_inst.hex hhb_runtime_sim_data.hex
