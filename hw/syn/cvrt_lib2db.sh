#!/bin/bash
MATCH_NAME="*180a_tt1v25c.lib"
TAR_DIR="/home/ic/tsmc28/MC2_2012.02.00.d/Memory/tsn28hpcpd127spsram_20120200_180a/AN61001_20180416/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a"

# Temporary TCL batch file (with .tcl extension)
tcl_file=$(mktemp /tmp/lib2db.XXXXXX).tcl

# Array to collect db paths
db_paths=()

# Loop through matches and build TCL commands
while IFS= read -r f; do
    dir_path=$(dirname "$f")
    db_name=$(basename "$f" .lib)
    db_path="${dir_path}/${db_name}.db"
    lc_name="${db_name/_180a/}"

    {
        echo "read_lib $f"
        echo "write_lib $lc_name -format db -output $db_path"
    } >> "$tcl_file"

    db_paths+=("$db_path")
done < <(find "${TAR_DIR}" -type f -name "${MATCH_NAME}")

# Add exit at the end of the TCL script
echo "exit" >> "$tcl_file"

# Run lc_shell once
echo "Start lib to db conversion ..."
lc_shell -f "$tcl_file"

# Clean up
rm -f "$tcl_file"
rm -f "lc_command.log" "lc_output.txt"

# Print summary list
echo
echo "✅ Conversion completed. The generated DB files are:"
for path in "${db_paths[@]}"; do
    echo "$path"
done