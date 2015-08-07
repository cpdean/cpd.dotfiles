if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
#eval `ssh-agent`  # This doesn't really work. too many processes left behind

#export PATH="/usr/local/bin:$PATH"
export AWS_CREDENTIAL_FILE=/Users/conrad/.aws_credential_file


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
