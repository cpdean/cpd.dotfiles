
# Completion script for SBCL

function __fish_sbcl_no_command
    for i in (commandline -opc)
        switch $i
            case '*--end-runtime-options*'
                return 1
        end
    end
    return 0
end

function __fish_sbcl_no_toplevel_command
    for i in (commandline -opc)
        switch $i
            case '*--end-toplevel-options*'
                return 1
        end
    end
    return 0
end

# Runtime options
complete -c sbcl -n '__fish_sbcl_no_command' -l core -a 'corefilename' -d 'Use the specified Lisp core file'
complete -c sbcl -n '__fish_sbcl_no_command' -l dynamic-space-size -a 'megabytes' -d 'Size of the dynamic space in megabytes'
complete -c sbcl -n '__fish_sbcl_no_command' -l control-stack-size -a 'megabytes' -d 'Size of control stack for each thread in megabytes'
complete -c sbcl -n '__fish_sbcl_no_command' -l noinform -d 'Suppress the startup banner'
complete -c sbcl -n '__fish_sbcl_no_command' -l disable-ldb -d 'Disable the low-level debugger'
complete -c sbcl -n '__fish_sbcl_no_command' -l lose-on-corruption -d 'Invoke ldb or exit on dangerous low-level errors'
complete -c sbcl -n '__fish_sbcl_no_command' -l script -a 'filename' -d 'Run as script'
complete -c sbcl -n '__fish_sbcl_no_command' -l merge-core-pages -d 'Provide hints to OS for sharing identical pages'
complete -c sbcl -n '__fish_sbcl_no_command' -l no-merge-core-pages -d 'Ensure no sharing hint is provided to OS'
complete -c sbcl -n '__fish_sbcl_no_command' -l help -d 'Print basic information about SBCL'
complete -c sbcl -n '__fish_sbcl_no_command' -l version -d 'Print SBCL version information'

# Toplevel options
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l sysinit -a 'filename' -d 'Load specified system-wide initialization file'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l no-sysinit -d 'Do not load system-wide initialization file'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l userinit -a 'filename' -d 'Load specified user initialization file'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l no-userinit -d 'Do not load user initialization file'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l eval -a 'command' -d 'Read and evaluate command'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l load -a 'filename' -d 'Equivalent to --eval (load "filename")'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l noprint -d 'Execute read-eval loop without printing prompt or results'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l disable-debugger -d 'Disable debugger and print backtrace on errors'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l quit -d 'Exit SBCL after processing toplevel options'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l non-interactive -d 'Disable read-eval-print loop for batch processing'
complete -c sbcl -n '__fish_sbcl_no_toplevel_command' -l script -a 'filename' -d 'Run script and exit'

# End options
complete -c sbcl -f -l end-runtime-options -d 'End of runtime options'
complete -c sbcl -f -l end-toplevel-options -d 'End of toplevel options'



# Description: Fish completions for SBCL

# Function to provide completions for SBCL commands
function __fish_sbcl_no_subcommand --description 'Test for general sbcl command'
    set cmd (commandline -opc)
    for c in $cmd
        if test $c = 'sbcl'
            return 0
        end
    end
    return 1
end

# Basic completions for SBCL
complete -c sbcl -d 'Steel Bank Common Lisp' -n '__fish_sbcl_no_subcommand' -f

# Common options for SBCL
complete -c sbcl -n '__fish_sbcl_no_subcommand' -s -h -l help -d 'Show help message'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -s -v -l version -d 'Show version information'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -s -q -l quit -d 'Quit immediately'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -s -i -l noinform -d 'Suppress startup message'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -s -n -l non-interactive -d 'Run non-interactively'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -s -s -l script -d 'Run script and exit'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l load -d 'Load a specified file'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l core -d 'Use specified core file'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l dynamic-space-size -d 'Set the dynamic space size'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l control-stack-size -d 'Set the control stack size'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l no-userinit -d 'Do not load user init file'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l no-sysinit -d 'Do not load system init file'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l disable-debugger -d 'Disable the debugger'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l eval -d 'Evaluate a form before REPL starts'
complete -c sbcl -n '__fish_sbcl_no_subcommand' -l end-runtime-options -d 'Terminate runtime options'

# Example usage: `sbcl --dynamic-space-size=<size>` will autocomplete the `--dynamic-space-size` option.
