if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
#eval `ssh-agent`  # This doesn't really work. too many processes left behind

export PATH="/usr/local/bin:$PATH"
export AWS_CREDENTIAL_FILE=/Users/deanc/.aws_credential_file


# startup virtualenv-burrito
if [ -f $HOME/.venvburrito/startup.sh ]; then
    . $HOME/.venvburrito/startup.sh
fi
