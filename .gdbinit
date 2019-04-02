set auto-load gdb-scripts on
add-auto-load-safe-path /home/cj/scripts
set auto-load scripts-directory /home/cj/scripts/gdb

# These files can be included in any session.
# They only provide macros.
source /home/cj/scripts/gdb/asm-tools.gdb
