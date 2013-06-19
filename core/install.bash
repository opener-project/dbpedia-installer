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

language="${1}"
index="${2}"
script_dir=$(dirname $(readlink -f "${0}"))

# DBpedia configuration settings, these should only be changed for new releases
# of DBpedia.
dbpedia_url="https://github.com/dbpedia-spotlight/dbpedia-spotlight.git"
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

if [[ ! -f "${index}" ]]
then
    abort "The index file ${index} does not exist"
# Expand the (potential) relative path to the full path so we can be sure that
# later on the right file is used.
else
    index=$(readlink -f "${index}")
    index_name=$(basename "${index}")
fi

if [[ ! -d "${dbpedia_dir}" ]]
then
    echo 'dbpedia-spotlight directory does not exist, creating...'

    if ! hash git 2>/dev/null
    then
        abort 'Git (http://git-scm.com/) is not installed, aborting...'
    fi

    git submodule update --init
fi

echo 'Copying Maven configuration files to the dbpedia-spotlight directory...'

cp -f "${script_dir}/conf/server_${language}.properties" \
    "${dbpedia_dir}/conf"

echo 'Creating directory for the indexes...'
enter_directory $dbpedia_dir
mkdir -p data

echo 'Preparing indexes...'
enter_directory data
cp -f "${index}" .
tar -xvf "${index_name}"
rm "${index_name}"

echo 'Creating dbpedia-spotlight JAR archive...'
enter_directory ../dist
mvn clean package

echo 'Installing dbpedia-spotlight JAR as a local maven repository...'

mvn install:install-file \
    -Dfile=target/dbpedia-spotlight-0.6-jar-with-dependencies.jar \
    -DgroupId=ixa -DartifactId=dbpedia.spotlight -Dversion=0.6 \
    -Dpackaging=jar -DgeneratePom=true

enter_directory "${old_pwd}"

echo 'Finished installing'
