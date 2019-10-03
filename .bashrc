# check where you are, then do those things instead

_check_os () {
    uname -v | grep -i $1 > /dev/null
}

if _check_os darwin; then
    source ~/.bashrc.darwin
elif _check_os ubuntu; then
    source ~/.bashrc.ubuntu
else
    echo "unknown operating system: `uname -v`"
    echo "fix ~/.bashrc hook"
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
