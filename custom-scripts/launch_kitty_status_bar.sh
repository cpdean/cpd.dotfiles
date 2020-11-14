#!/usr/bin/env bash
STATUS_BAR_CMD="`which python` ~/.dotfiles/custom-scripts/kitty_status_bar.py $KITTY_WINDOW_ID"
STATS_BAR_WINDOW="statusbarfor$KITTY_WINDOW_ID"
# keep open for a bit so i can see why it breaks
#kitty @ launch --keep-focus --title $STATS_BAR_WINDOW --location=hsplit bash -c "sleep 1; $STATUS_BAR_CMD; sleep 3"
kitty @ launch --keep-focus --title $STATS_BAR_WINDOW --location=hsplit bash -c "sleep 1; $STATUS_BAR_CMD; sleep 30"
# TODO: resize it down to 1 char.
# but i have no idea how lol
sleep 1
kitty @ resize-window --match=title:$STATS_BAR_WINDOW -i=-1 -a=vertical
sleep 1
kitty @ resize-window --match=title:$STATS_BAR_WINDOW -i=-1 -a=vertical
sleep 1
kitty @ resize-window --match=title:$STATS_BAR_WINDOW -i=-1 -a=vertical
sleep 1
kitty @ resize-window --match=title:$STATS_BAR_WINDOW -i=-1 -a=vertical
sleep 1
kitty @ resize-window --match=title:$STATS_BAR_WINDOW -i=-1 -a=vertical
