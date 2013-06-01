if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
#eval `ssh-agent`  # This doesn't really work. too many processes left behind

export PATH="/usr/local/bin:$PATH"


# startup virtualenv-burrito
if [ -f $HOME/.venvburrito/startup.sh ]; then
    . $HOME/.venvburrito/startup.sh
fi
