function fish_prompt -d "Write out the prompt"
    # need to save this before we run any other commands in here
    set previous_command_status $status
    if test "$previous_command_status" != "0"
    printf '%s%s%s %s%s%s > ' \
        (set_color $fish_color_status) $previous_command_status (set_color normal) \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    else
    printf '%s%s%s > ' \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    end
end
