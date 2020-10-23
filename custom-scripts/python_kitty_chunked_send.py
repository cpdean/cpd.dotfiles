#!/usr/bin/env python
import sys
import io
import subprocess

# q and ctrl-u
default_reset = "q\025"

# warning: this buffers all of stdin into memory
lines = sys.stdin.readlines()
batch_size = 40

kitty = subprocess.run(
    ["kitty", "@", "send-text", "--match=num:1", "--stdin"],
    input=default_reset,
    encoding='ascii'
)

for i in range(0, len(lines), batch_size):
    batch = lines[i:i+batch_size]
    kitty = subprocess.run(
        ["kitty", "@", "send-text", "--match=num:1", "--stdin"],
        input=''.join(batch),
        encoding='ascii'
    )
