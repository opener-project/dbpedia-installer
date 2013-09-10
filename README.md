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
done by running the script `core/install.bash`. This script takes two
arguments: a language for the index to use and a Tar archive containing Lucene
indexes. For example:

    bash core/install.bash en /tmp/index-en.tar.gz

The following languages are supported:

* Dutch (nl)
* English (en)
* French (fr)
* German (de)
* Italian (it)
* Spanish (es)

Each language will run on its own port based on the configuration files found
in `core/conf`. The following ports are used:

* German: 2010
* English: 2020
* Spanish: 2030
* French: 2040
* Italian: 2050
* Dutch: 2060

## Running The Application

Before you start make sure that there's a data directory for your indexes in
`core/dbpedia-installer/data` and that the JAR archive (including all
dependencies) has been created.

Once this has been taken care of you can start the application as following:

    cd core/dbpedia-installer/conf

    java -jar \
        ../../dbpedia-spotlight/dist/target/dbpedia-spotlight-$version-jar-with-dependencies.jar \
        server_$lang.properties

Here `$version` is the version of dbpedia-spotlight and `$lang` the language
configuration file to use.

If you get an error such as `Similarity threshold file
'similarity-thresholds.txt' not found in index directory ../data/index-en` it
means that you don't have any proper indexes installed.

## Creating Disambiguation Indexes

In order to actually use the index files you first have to create them. The
instructions for doing this can be found [here][creating-index]. OpeNER members
can also download pre-created index files for various languages from the OpeNER
S3 bucket.

[creating-index]: https://github.com/opener-project/EHU-DBpedia-Spotlight/wiki/DBpedia-Spotlight-Internationalization-for-OpeNER
