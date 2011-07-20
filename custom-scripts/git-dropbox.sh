#!/bin/bash
name=$1
current_directory=`pwd`
project_location="`pwd`/${name}"
#git_repo_location="~/Dropbox/git/${name}.git"  # for some reason relative paths don't work?
repos=~/Dropbox/git
git_repo_location="${repos}/${name}.git"

# Halt the script if the repo or the directory already exists
# and alert the user about that problem.
if [ -e $project_location -o -e $git_repo_location ]; then
#if [ -e $git_repo_location -o -e $project_location ]; then
    if [ -e $project_location ]; then
        echo "ERROR"
        echo "$project_location already exists, please choose a different name"
        echo "or delete $project_location and try again."
    fi
    if [ -e $git_repo_location ]; then
        echo "ERROR"
        echo "$git_repo_location already exists, please choose a different name"
        echo "or delete $git_repo_location and try again."
    fi
    exit
fi

echo making repository at $project_location

git init $project_location
cd $project_location
echo $name >> README.markdown
git add .
git commit -m "first commit"

echo and making git repo $git_repo_location

mkdir $git_repo_location
cd $git_repo_location
git init --bare
cd $project_location

echo first push

git remote add origin $git_repo_location
git push origin master

echo Done.  You may now begin working on $name.
