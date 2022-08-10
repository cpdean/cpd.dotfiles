if status --is-login
    # TODO: intel homebrew
    if test -f /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end
    fish_add_path -g --prepend $HOME/.cargo/bin
    fish_add_path -g --prepend $HOME/.dotfiles/custom-scripts/

    # intel macos puts some things here so
    fish_add_path -g --prepend /usr/local/sbin
    set -x EDITOR nvim


end

if status is-interactive
    # i think im good without the greeting for now
    set fish_greeting

    # old habits
    abbr -g vim nvim

    # ls for my gits
    abbr -g gs git status

    set -x FZF_DEFAULT_COMMAND 'fd --type f'
    set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"

end
