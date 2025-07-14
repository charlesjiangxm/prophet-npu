#!/bin/tcsh  

setenv CODE_BASE_PATH `readlink -f ../rtl`  
echo "Root of code base has been specified as:"  
echo "$CODE_BASE_PATH"  

# the open-xuantie gcc-linux compiler
setenv TOOL_EXTENSION `realpath /data/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.1.0/bin`  
echo 'Toolchain path($TOOL_EXTENSION):'  
echo "$TOOL_EXTENSION"  