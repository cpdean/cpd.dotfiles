#!/bin/bash
ruby -pe 'sleep 0.1' | kitty @ send-text --match=num:1 --stdin
