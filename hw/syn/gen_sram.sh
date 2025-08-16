#!/bin/bash
env MC_HOME=$(pwd)
./tsn28hpcpd127spsram_180a.pl -file config.txt -LVT -PVT tt1v25c

for file in $(find . -name "ts1n28hpcpuhdlvt*.cfg")
do
  echo "====== Compile $file ======"
  mc2-eu -eu -c tsn28hpcpd127spsram_20120200_180a.mco -cfg $file -ui textual -v -p tsmceva -d ./
  rm $file
done
