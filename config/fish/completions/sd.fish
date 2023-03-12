# Completions for the custom Script Directory (sd) script

# These are based on the contents of the Script Directory, so we're reading info from the files.
# The description is taken either from the first line of the file $cmd.help,
# or the first non-shebang comment in the $cmd file.

# Disable file completions
complete -c sd -f

set __sd_bin "$(sd --bin-path)"
# Create command completions for a subcommand
# Takes a list of all the subcommands seen so far
function __list_subcommand
    # Handles fully nested subcommands
    set basepath (string join '/' "$__sd_bin" $argv)

    # Total subcommands
    # Used so that we can ignore duplicate commands
    set -l commands
    for file in (ls -d $basepath/*)
        set cmd (basename $file .help)
        set helpfile $cmd.help
        if [ (basename $file) != "$helpfile" ]
            set commands $commands $cmd
        end
    end

    # Setup the check for when to show these commands
    # Basically you need to have seen everything in the path up to this point but not any commands in the current directory.
    # This will cause problems if you have a command with the same name as a directory parent.
    set check
    for arg in $argv
        set check (string join ' and ' $check "__fish_seen_subcommand_from $arg;")
    end
    set check (string join ' ' $check "and not __fish_seen_subcommand_from $commands")

    # Loop through the files using their full path names.
    for file in (ls -d $basepath/*)
        set cmd (basename $file .help)
        set helpfile $cmd.help
        if [ (basename $file) = "$helpfile" ]
            # This is the helpfile, use it for the help statement
            set help (head -n1 "$file")
            complete -c sd -a "$cmd" -d "$help" \
                -n $check
        else if test -d "$file"
            set help "$cmd commands"
            __list_subcommand $argv $cmd
            complete -c sd -a "$cmd" -d "$help" \
                -n "$check"
        else
            set help (sed -nE -e '/^#!/d' -e '/^#/{s/^# *//; p; q;}' "$file")
            if not test -e "$helpfile"
                complete -c sd -a "$cmd" -d "$help" \
                    -n "$check"
            end
        end
    end
end

function __list_commands
    # commands is used in the completions to know if we've seen the base commands
    set -l commands


    # Create a list of commands for this directory.
    # The list is used to know when to not show more commands from this directory.
    for file in $argv
        set cmd (basename $file .help)
        set helpfile $cmd.help
        if [ (basename $file) != "$helpfile" ]
            # Ignore the special commands that take the paths as input.
            if not contains $cmd cat edit help new which
                set commands $commands $cmd
            end
        end
    end
    for file in $argv
        set cmd (basename $file .help)
        set helpfile $cmd.help
        if [ (basename $file) = "$helpfile" ]
            # This is the helpfile, use it for the help statement
            set help (head -n1 "$file")
            complete -c sd -a "$cmd" -d "$help" \
                -n "not __fish_seen_subcommand_from $commands"
        else if test -d "$file"
            # Directory, start recursing into subcommands
            set help "$cmd commands"
            __list_subcommand $cmd
            complete -c sd -a "$cmd" -d "$help" \
                -n "not __fish_seen_subcommand_from $commands"
        else
            # Script
            # Pull the help text from the first non-shebang commented line.
            set help (sed -nE -e '/^#!/d' -e '/^#/{s/^# *//; p; q;}' "$file")
            if not test -e "$helpfile"
                complete -c sd -a "$cmd" -d "$help" \
                    -n "not __fish_seen_subcommand_from $commands"
            end
        end
    end
end

function _debug
    set var_name $argv
    # not sure the safe way to do this
    eval "$going_to_run"
end

__list_commands $__sd_bin/*
