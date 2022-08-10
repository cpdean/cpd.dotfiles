if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status --is-login
    # TODO: intel homebrew
    if test -f /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end
    fish_add_path -g --prepend $HOME/.cargo/bin
    set -x EDITOR nvim

    abbr -g vim nvim

end
