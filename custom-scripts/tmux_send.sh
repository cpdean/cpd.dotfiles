#!/bin/bash
tmpfile=$(mktemp /tmp/tmux_send_buffer.XXXXXX)
cat - > $tmpfile
tmux -L default load-buffer $tmpfile
tmux -L default paste-buffer -d -t {last}
rm $tmpfile
