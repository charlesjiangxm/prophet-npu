#!/bin/bash

# the link only flow
cp ../utils/Makefile_Link hhb_out/Makefile
cd hhb_out
make all

# the compile from .c flow
# this script will force the program starts at 0x10000000
# cp ../utils/Makefile_All hhb_out/Makefile
# cp ../utils/linker.lcf hhb_out/linker.lcf
# cp ../utils/crt0.s hhb_out/crt0.s
# cd hhb_out
# make all
