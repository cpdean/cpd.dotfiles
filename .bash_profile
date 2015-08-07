export PATH="/usr/local/bin:$PATH"
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
#eval `ssh-agent`  # This doesn't really work. too many processes left behind

export AWS_CREDENTIAL_FILE=/Users/deanc/.aws_credential_file
export AWS_SECRET_ACCESS_KEY=$(cat $AWS_CREDENTIAL_FILE | grep -i secret | cut -d "=" -f 2)
export AWS_ACCESS_KEY_ID=$(cat $AWS_CREDENTIAL_FILE | grep -i access | cut -d "=" -f 2)
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
# export ORACLE_HOME=/usr/local/lib/instantclient
# export LD_LIBRARY_PATH=$ORACLE_HOME
# export DYLD_LIBRARY_PATH=$ORACLE_HOME
# export VERSIONER_PYTHON_PREFER_32_BIT=yes

# The next line updates PATH for the Google Cloud SDK.
source '/Users/deanc/google-cloud-sdk/path.bash.inc'

# The next line enables bash completion for gcloud.
source '/Users/deanc/google-cloud-sdk/completion.bash.inc'
