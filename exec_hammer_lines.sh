#!/bin/bash

if [ "$#" -ne 1 ]; then
  batch_size=4
else
  batch_size="$1"
fi

cmds="hammer_cmds"

line_cnt=0
batch=()

while IFS= read -r line; do
  batch+=("$line")
  line_cnt=$((line_cnt+1))
  if [ "$line_cnt" -eq "$batch_size" ]; then
    for line in "${batch[@]}"; do
      eval "$line" &
    done
    wait
    batch=()
    line_cnt=0
  fi
done < "$cmds"

for line in "${batch[@]}"; do
  eval "$line" &
done
wait
