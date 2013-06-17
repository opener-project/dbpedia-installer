#!/usr/bin/env bash

set -e

##
# Enters the directory given in the first argument and notifies the user about
# this.
#
# @param [String] $1 The directory to change the current working directory to.
#
enter_directory()
{
    full_path=$(readlink -f $1)

    echo "Changing PWD to ${full_path}"
    cd $1
}

##
# Shows the message passed as the first argument and terminates the script.
#
# @param [String] $1 The message to display.
#
abort()
{
    echo $1
    exit 1
}

##
# Copies over a file and backs up existing files. If a backup already exists
# this function doesn't overwrite it again.
#
# @param [String] $1 The source file.
# @param [String] $2 The destination file.
#
copy_file()
{
    if [[ ! -f "$2.orig" ]]
    then
        cp --backup --suffix=.orig -f $1 $2
    else
        "Backup file for ${2} already exists, ignoring"
    fi
}

language=$1
index=$2
script_dir=$(dirname $(readlink -f $0))
dbpedia_git="https://github.com/dbpedia-spotlight/dbpedia-spotlight.git"
dbpedia_dir="${script_dir}/dbpedia-spotlight"
old_pwd=$(pwd)

if [[ -z "${language}" ]]
then
    abort "You must specify a language as the first argument"
fi

if [[ -z "${index}" ]]
then
    abort "You must specify an index file as the second argument"
fi

if [[ ! -f $index ]]
then
    abort "The index file ${index} does not exist"
# Expand the (potential) relative path to the full path so we can be sure that
# later on the right file is used.
else
    index=$(readlink -f $index)
    index_name=$(basename $index)
fi

if [[ ! -d $dbpedia_dir ]]
then
    echo 'dbpedia-spotlight directory does not exist, creating...'

    if ! hash git 2>/dev/null
    then
        abort 'Git (http://git-scm.com/) is not installed, aborting...'
    fi

    git clone $dbpedia_git $dbpedia_dir
fi

echo 'Copying Maven configuration files to the dbpedia-spotlight directory...'

copy_file "${script_dir}/pom.xml" $dbpedia_dir
copy_file "${script_dir}/core/pom.xml" "${dbpedia_dir}/core"

copy_file "${script_dir}/conf/server_${language}.properties" \
    "${dbpedia_dir}/conf"

echo 'Installing dependencies for all Maven projects...'
enter_directory $dbpedia_dir
mvn clean install

echo 'Creating dbpedia-spotlight JAR archive...'
enter_directory dist
mvn clean package

echo 'Creating directory for the indexes...'
enter_directory ..
mkdir -p data

echo 'Preparing indexes...'
enter_directory data
cp -f $index .
tar -xvf $index_name
rm $index_name

enter_directory $old_pwd

echo 'Finished installing'
