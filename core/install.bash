#!/bin/bash

LANG=$1
INDEX=$2
SPOTLIGHTDIR="dbpedia-spotlight";

cd ../../

if [ -d $SPOTLIGHTDIR ]
then
    echo "dbpedia spotlight already exists skipping the step of downloading it";
else
    echo "downloading dbpedia spotlight";
    git clone https://github.com/dbpedia-spotlight/dbpedia-spotlight.git
fi

cd $SPOTLIGHTDIR

if [ -e pom.xml.orig ]
then
    echo "the original pom.xml files have been already replaced, skipping the replacement"
else
    mv pom.xml pom.xml.orig
    mv core/pom.xml core/pom.xml.orig
    cd ../EHU-DBpedia-spotlight/core
    cp pom.xml ../../dbpedia-spotlight/.
    cp core/pom.xml ../../dbpedia-spotlight/core/.
    cp conf/server_*.properties ../../dbpedia-spotlight/conf/.
fi

cd ../../
cd $SPOTLIGHTDIR
echo "installing the modified dbpedia spotlight"
mvn clean install

echo "creating the jar with dependencies"
cd dist
mvn clean package

echo "creating a directory to store the indexes..."
cd ..

if [ -d data ]
then
    echo "moving to data directory"
else
    mkdir data
    echo "making data directory"
fi

cd data

if [ -e index-$LANG.tgz ]
then
    echo "unzipping index ..."
    tar xzvf index-$LANG.tgz
    echo "DONE"
else
    cd $SPOTLIGHTDIR
    echo "Getting  index..."
    mv $INDEX ./data/
    cd data/
    tar xvzf $INDEX
    echo "DONE"
fi

echo "Installation completed."
