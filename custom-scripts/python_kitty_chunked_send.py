#!/usr/bin/env python3

"""
this is for sending text from the main window of a kitty tab to the window that
holds the repl

TODO: this could be made smarter to take in a custom --match= so that editor tooling
      can control how to instantiate the repl and send to the correct window

test

echo echo sup | kitty @ send-text --match=num:1 --stdin

"""
import sys
import io
import subprocess

if "-r" in sys.argv:
    default_reset = ""
else:
    # q and ctrl-u
    default_reset = "q\025"

# warning: this buffers all of stdin into memory
lines = sys.stdin.readlines()
batch_size = 10

# lump this into the first batch to speed up flushing
batch = [default_reset]

for i in range(0, len(lines), batch_size):
    batch += lines[i:i+batch_size]
    # check if you're at the end of the input and make sure to add
    # a new-line character if it was missing
    if len(lines) <= (i + batch_size) and batch[-1][-1] != "\n":
        batch[-1] += "\n"

    kitty = subprocess.run(
        ["kitty", "@", "send-text", "--match=num:1", "--stdin"],
        input=''.join(batch),
        encoding='ascii'
    )
    batch = []
