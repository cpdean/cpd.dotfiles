#!/usr/bin/env python
import time
import os
import sys
import subprocess
import json

status_window_id = int(os.environ.get("KITTY_WINDOW_ID"))
KITTY = "/usr/local/bin/kitty"

def get_tab_of_window(kitty_ls, window_id):
    """
    # TODO: this is a hard-coded traversal
    """
    # TODO: assume only one oswindow
    current_os_window = kitty_ls[0]
    tabs = current_os_window['tabs']
    for tab in tabs:
        for w in tab['windows']:
            if w['id'] == status_window_id:
                return tab


def get_window(kitty_ls, window_id):
    # TODO: assume only one oswindow
    current_os_window = kitty_ls[0]
    tabs = current_os_window['tabs']
    for tab in tabs:
        for w in tab['windows']:
            if w['id'] == window_id:
                return w


def get_cwd(kitty_ls, window_id):
    window = get_window(kitty_ls, window_id)
    return window['cwd']

def get_git_branch(cwd):
    running = subprocess.run(
        ["git", "branch"],
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if running.returncode == 0:
        # remove leading '* ' and trailing '\n'
        return running.stdout.strip()[2:]
    else:
        # silently
        return b''

def git_count_uncomitted_files(cwd):
    running = subprocess.run(
        ["git", "status", "-s"],
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if running.returncode == 0:
        return len([i for i in running.stdout.split(b'\n') if i != b''])
    else:
        # silently
        return []

def refresh_bar(target_window_id):
    kitty_ls = json.loads(
        subprocess.run([KITTY, "@", "ls"], stdout=subprocess.PIPE).stdout
    )
    target_cwd = get_cwd(kitty_ls, target_window_id)
    git_branch = get_git_branch(target_cwd)
    touched_files = len(git_count_uncomitted_files(target_cwd))
    formatted_touched_files = touched_files if touched_files > 0 else ''
    print(
        f"\n{target_cwd} {git_branch.decode()} {formatted_touched_files}",
        end="" # so that it's flush with the bottom of the screen
    )

def main():
    target_id = int(sys.argv[1])

    while True:
        try:
            refresh_bar(target_id)
            time.sleep(10)
        except KeyboardInterrupt as e:
            print()
            break

if __name__ == "__main__":
    main()
