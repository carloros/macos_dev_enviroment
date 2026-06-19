#!/bin/sh

PAGE_SIZE=$(vm_stat | awk '/page size of/ {print $8}')
ACTIVE=$(vm_stat | awk '/Pages active/ {gsub(/\./,"",$3); print $3}')
WIRED=$(vm_stat | awk '/Pages wired down/ {gsub(/\./,"",$4); print $4}')
COMPRESSED=$(vm_stat | awk '/Pages occupied by compressor/ {gsub(/\./,"",$5); print $5}')

USED=$(( (ACTIVE + WIRED + COMPRESSED) * PAGE_SIZE / 1073741824 ))
TOTAL=$(( $(sysctl -n hw.memsize) / 1073741824 ))

sketchybar --set "$NAME" icon="" label="${USED}G/${TOTAL}G"
