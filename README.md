# DBpedia Installer

This repository contains the source code for starting up a custom version of
dbpedia-spotlight for the OpeNER project. It takes care of locally installing
the dbpedia-spotlight and configuring.

## Requirements

* Java 1.7 or newer
* Maven 3
* 10-50GB of disk space depending on the size of your index files (and the
  amount of files you'd like to use)
* Bash

## Installation

Assuming you have cloned this repository setting up the dbpedia instance can be
done by running the script `core/install.bash`. This script takes as argument the dbpedia-spotlight.jar: 

For example:

    bash core/install.bash dbpedia-spotlight.jar  

The following languages are supported:

* Dutch (nl)
* English (en)
* French (fr)
* German (de)
* Italian (it)
* Spanish (es)

Each language will run on its own port. The following ports are used:

* German: 2010
* English: 2020
* Spanish: 2030
* French: 2040
* Italian: 2050
* Dutch: 2060

## Running The Application

Before you start make sure that the core/ directory holds: 

* All the models, one for each language untarred.  
* The dbpedia-spotlight.jar
* That you have execute the core/install.bash script to create the maven local repository for
  dbpedia-spotlight.jar. 

Once this has been taken care of you can start the application as following:

    cd core/

    java -jar dbpedia-spotlight.jar $lang http://localhost:$port/rest 

Here `$lang` is the language to be used, and $port is the port into which run the server for that
language, following the list above. 

If you get an error such as `Similarity threshold file
'similarity-thresholds.txt' not found` it means that you don't have any models in your core directory.

OpeNER members can download pre-created model files and dbpedia-spotlight.jar from the OpeNER
S3 bucket. Just get the spotlight-statistical directory and place its contents in the core/ directory. 

