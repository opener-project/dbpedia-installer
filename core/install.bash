#!/bin/bash

SPOTLIGHTDIR="dbpedia-spotlight";

cd ..

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
    cd ../IXA-EHU-DBpedia-spotlight
    cp pom.xml ../dbpedia-spotlight/.
    cp core/pom.xml ../dbpedia-spotlight/core/.
    cp conf/server_en.properties ../dbpedia-spotlight/conf/.
    cp conf/server_es.properties ../dbpedia-spotlight/conf/.
fi

cd ..
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

if [ -e index-en.tgz ]
then
    echo "unzipping English index..."
    tar xzvf index-en.tgz
    echo "DONE"
else
    echo "Getting English index..."
    wget --no-check-certificate 'https://siuc05.si.ehu.es/~ragerri/index-spotlight/index-en.tgz'
    tar xvzf index-en.tgz
    echo "DONE"
fi

if [ -e index-es.tgz ]
then
    echo "unzipping Spanish index..."
    tar xzvf index-es.tgz
    echo "DONE"
else
    echo "Getting Spanish index..."
    wget --no-check-certificate 'https://siuc05.si.ehu.es/~ragerri/index-spotlight/index-es.tgz'
    tar xvzf index-es.tgz
    echo "DONE"
fi

echo "Finding pos-en-general-brown.HiddenMarkovModel..."
cd ..
find . -name "*pos-en-general-brown.HiddenMarkovModel*"
echo "done"
echo "Please change the server_en.properties and server_es.properties file to correctly point out to the current location of pos-en-general-brown.HiddenMarkovModel"

echo "Installation completed."
