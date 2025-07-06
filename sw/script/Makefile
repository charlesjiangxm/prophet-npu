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
CC      = ${TOOL_EXTENSION}/riscv64-unknown-elf-gcc-10.4.0
AS      = ${TOOL_EXTENSION}/riscv64-unknown-elf-as
LINK    = ${TOOL_EXTENSION}/riscv64-unknown-elf-ld
OBJDUMP = ${TOOL_EXTENSION}/riscv64-unknown-elf-objdump
OBJCOPY = ${TOOL_EXTENSION}/riscv64-unknown-elf-objcopy
CONVERT		=../tests/bin/Srec2vmem

SSRC = $(wildcard *.S)
sSRC = $(wildcard *.s)
CSRC = $(wildcard *.c)

OBJECTS = $(SSRC:%.S=%.o) $(sSRC:%.s=%.o) $(CSRC:%.c=%.o)

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

FLAG_ABI   = -mabi=lp64d
FLAG_MARCH = -march=rv64gcv0p7_zfh_xtheadc
CFLAGS = -O2 -g ${FLAG_MARCH} ${FLAG_ABI} ${INCLUDE}

LINKFLAGS = -Tlinker.lcf -nostartfiles ${FLAG_MARCH} ${FLAG_ABI}
# LDFLAGS = -lc -lgcc
LDFLAGS += -Wl,--gc-sections -O2 -g -mabi=lp64d -lshl -fopenmp -static -lprebuilt_runtime -ljpeg -lpng -lz -lstdc++ -lm
OBJDUMPFLAGS = -S -Mnumeric
HEXFLAGS	= -O srec

%.o : %.c
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.s
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.S
	${CC} -c ${CFLAGS} -o $@ $<

${FILE}.elf : ${OBJECTS} linker.lcf
	${CC} ${LINKFLAGS} ${LDFLAGS} ${OBJECTS} -o $@ -lm 

${FILE}.obj : ${FILE}.elf
	${OBJDUMP} ${OBJDUMPFLAGS} $< > $@

INST_HEX = ${FILE}_inst.hex
DATA_HEX = ${FILE}_data.hex
FILE_HEX = ${FILE}.hex

${FILE}.hex : ${FILE}.elf
	${OBJCOPY} ${HEXFLAGS} $< ${INST_HEX} -j .text*  -j .rodata* -j .eh_frame*
	${OBJCOPY} ${HEXFLAGS} $< ${DATA_HEX} -j .data*  -j .bss -j .COMMON
	${OBJCOPY} ${HEXFLAGS} $< $@ 

INST_PAT = inst.pat
DATA_PAT = data.pat
FILE_PAT = case.pat

%.pat	: %.hex
	rm -f *.pat
	${CONVERT} ${INST_HEX} ${INST_PAT}
	${CONVERT} ${DATA_HEX} ${DATA_PAT}
	${CONVERT} ${FILE_HEX} ${FILE_PAT}

#--------------------------------------------------------------------
# phony
.PHONY :all
all : ${FILE}.pat ${FILE}.hex ${FILE}.elf ${FILE}.obj

.PHONY :elf
elf : ${FILE}.elf

.PHONY :clean 
clean:
	rm -rf *.o *.pat *.elf *.obj *.hex
