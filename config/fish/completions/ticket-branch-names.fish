# stolen from fish completions because i dont know what it does

# Print an optspec for argparse to handle git's options that are independent of any subcommand.
function __fish_git_global_optspecs
    string join \n v-version h/help C= c=+ 'e-exec-path=?' H-html-path M-man-path I-info-path p/paginate \
        P/no-pager o-no-replace-objects b-bare G-git-dir= W-work-tree= N-namespace= S-super-prefix= \
        l-literal-pathspecs g-glob-pathspecs O-noglob-pathspecs i-icase-pathspecs
end

function __fish_git_using_command
    set -l cmd (__fish_git_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd $argv
    and return 0

    # Check aliases.
    set -l varname __fish_git_alias_(string escape --style=var -- $cmd)
    set -q $varname
    and contains -- $$varname[1][1] $argv
    and return 0
    return 1
end

function __fish_git_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_git_global_optspecs) -- $cmd 2>/dev/null
    or return 0
    # These flags function as commands, effectively.
    set -q _flag_version; and return 1
    set -q _flag_html_path; and return 1
    set -q _flag_man_path; and return 1
    set -q _flag_info_path; and return 1
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end


function __my_jira_tickets
    # should be on path
    my-jira.sh
end

#complete -e -c git -n '__fish_git_using_command checkout' -n 'not contains -- -- (commandline -opc)'
#complete -f -c git -n '__fish_git_using_command checkout' -s b -e
complete -f -c git -n '__fish_git_using_command checkout' -s b -r -a "(__my_jira_tickets)" -d 'Create a new branch'
