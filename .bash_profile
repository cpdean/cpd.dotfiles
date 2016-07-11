export PATH="/usr/local/bin:$PATH"
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
#eval `ssh-agent`  # This doesn't really work. too many processes left behind

export JAVA_HOME=$(/usr/libexec/java_home)


#DISABLING BURRITO FOR NOW.
# i want a more legit venv setup
# startup virtualenv-burrito
#if [ -f $HOME/.venvburrito/startup.sh ]; then
    #. $HOME/.venvburrito/startup.sh
#fi

# added by Anaconda 1.9.1 installer
#export PATH="/Users/deanc/anaconda/bin:$PATH"

#Add oracle stuff for oracleDB.
# https://github.dowjones.net/NewsCloud/DJInsights-hadoop/tree/master/celery_jobs
#export ORACLE_HOME=/usr/local/lib/instantclient
#export LD_LIBRARY_PATH=$ORACLE_HOME
#export DYLD_LIBRARY_PATH=$ORACLE_HOME
#export VERSIONER_PYTHON_PREFER_32_BIT=yes

# broke this trying to upgrade and then un upgrade python and
# now looking at getting pyenv to work and good god why does jedi-vim
# no longer work
#source /usr/local/bin/virtualenvwrapper.sh


# Add GHC 7.10.3 to the PATH, via https://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.10.3.app"
if [ -d "$GHC_DOT_APP" ]; then
  export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi

# OPAM configuration
. /Users/cdean/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
