if status --is-login
    # M1
    if test -f /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end

    ## intel
    #if test -f /usr/local/bin/brew
    #    eval (/usr/local/bin/brew shellenv)
    #end

    fish_add_path -g --prepend $HOME/Library/Python/3.9/bin
    fish_add_path -g --prepend $HOME/.cargo/bin
    fish_add_path -g --prepend $HOME/.dotfiles/custom-scripts/
    fish_add_path -g --prepend $HOME/.local/bin/
    fish_add_path -g --prepend $HOME/go/bin/
    fish_add_path -g --prepend $HOME/.config/sd/
    fish_add_path -g (brew --prefix)/opt/llvm/bin
    fish_add_path -g (brew --prefix)/opt/openjdk/bin
    fish_add_path -g (brew --prefix)/opt/openjdk@17/bin

    set -x EDITOR nvim


end

if status is-interactive
    # i think im good without the greeting for now
    set fish_greeting

    # old habits
    abbr -g vim nvim

    # ls for my gits
    abbr -g gs git status -uno
    abbr -g gss git status

    abbr -g cd. cd ..
    abbr -g cd.. cd ../..
    abbr -g cd... cd ../../..

    abbr -g dc docker compose

    # short command to go somewhere specific
    abbr -g gp cd '$(find ~/dev/projects -maxdepth 1 | fzf)'
    abbr -g gf "cd $HOME/dev/foss/(fd --type d --maxdepth 2 . ~/dev/foss | sed -e \"s%$HOME/dev/foss/%%\" | fzf)"


    # love too python
    abbr -g vmake python3 -m venv venv
    abbr -g vuse source ./venv/bin/activate.fish

    # this is easier to do than the proper terminal support install kitty recommends
    abbr -g ssh "TERM=xterm ssh"

    set -x RIPGREP_CONFIG_PATH $HOME/.dotfiles/config/ripgreprc

    set -x FZF_DEFAULT_COMMAND 'fd --type f'
    # disabling because too many files
    # set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
    set -g FZF_CTRL_T_COMMAND "command fd --type f"

    set -x DOCKER_DEFAULT_PLATFORM "linux/amd64"

    # need to tell helix where to find stuff
    set -x HELIX_RUNTIME "/opt/homebrew/Cellar/helix/23.05/libexec/runtime"

    fzf --fish | source

end
