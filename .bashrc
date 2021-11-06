#set -x
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

############################################################
############################################################
########                                      ##############
########       DELETE EVERYTHING BELOW        ##############
########    THIS FILE IS ONLY FOR ROUTING     ##############
########              ----------              ##############
########  SOME OTHER TOOL ADDED CONFIG HERE,  ##############
########      SLOWING DOWN YOUR SHELL         ##############
########                                      ##############
############################################################
############################################################
