#!/bin/bash
while IFS= read -r line; do
    echo "$line" | kitty @ send-text --match=num:1 --stdin
done
