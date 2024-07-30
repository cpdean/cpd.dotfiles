# bash-like !!
# ref: https://github.com/fish-shell/fish-shell/issues/288#issuecomment-591679913
# ref: https://github.com/rouge8/dotfiles/blob/33ea74c55e112bd4d04789bf38256ae622e66238/.config/fish/functions/fish_user_key_bindings.fish.symlink#L3
function bind_bang --description 'bash-like !!'
    switch (commandline --current-token)[-1]
        case '!'
            # Without the `--`, the functionality can break when completing
            # flags used in the history (since, in certain edge cases
            # `commandline` will assume that *it* should try to interpret
            # the flag)
            commandline --current-token -- $history[1]
            commandline --function repaint
        case '*'
            commandline --insert !
    end
end

# bash-like !$
# ref: https://github.com/oh-my-fish/plugin-bang-bang
function bind_dollar --description 'bash-like !$'
    switch (commandline --current-token)[-1]
        case '!'
            # Without the `--`, the functionality can break when completing
            # flags used in the history (since, in certain edge cases
            # `commandline` will assume that *it* should try to interpret
            # the flag)
            commandline --current-token ""
            commandline --function history-token-search-backward
        case '*'
            commandline --insert '$'
    end
end


function fish_user_key_bindings
    bind '!' bind_bang
    bind '$' bind_dollar
end

