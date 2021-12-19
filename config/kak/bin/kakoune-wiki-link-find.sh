#!/usr/bin/env bash

# print out completion candidates for wiki pages to link to

# USAGE: ./kakoune-wiki-link-find.sh WIKIDIR
# WIKIDIR should be ${kak_opt_wiki_dir}
# INVOCATION_COORD should be "${kak_cursor_line}.${kak_cursor_column}@${kak_timestamp}"

# output format (per interfacing docs):
# line.column[+len]@timestamp candidate1|select1|menu1 candidate2|select2|menu2 ...
#

# i am going to just assume there is only one directory, and not worry about relative links in nested folders
#
# using a hard-coded output to experiment with the effects in kakoune
# echo "'goat_candidate1||goat_menu1' 'goat_candidate2|info -style menu %!goat_2_select!|goat_menu2'"
# candidate is written to the file, menu shows up as the menu item, and when a menu item is hovered over, it displays the 'select' text
#
# I've decided i do not need the select text, nor anything special for the item menu, so i'll just make them the same

# get all files, strip out the leading "./" and trailing .md, because the 'expand tag' function will add it back when
# it completes the markdown link
find . -name "*.md" |
    sed "s%^\./\(.*\).md$%\1%" |
    # TODO: do all the tilde, etc double escaping
    #       that kakone's rc/tool/{clang,jedi,racer}.kak does
    awk ' { printf "\047%s||%s\047 ", $1, $1 } ' # i cannot figure out how to render a single quote to wrap these
                                                 # so using byte 39, 47 octal, lol.

