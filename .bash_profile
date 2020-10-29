export PATH="/usr/local/bin:$PATH"
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
#eval `ssh-agent`  # This doesn't really work. too many processes left behind

if [ -f /usr/libexec/java_home ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi
