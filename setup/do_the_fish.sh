#!/bin/bash
# i have stolen this from andy, of course
FISH_BIN="$(brew --prefix)/bin/fish"
if ! grep -xq "$FISH_BIN" /etc/shells; then
  echo "Adding $FISH_BIN to /etc/shells..."
  echo "$FISH_BIN" | sudo tee -a /etc/shells
fi
chsh -s "$FISH_BIN"
