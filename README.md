# DBpedia Installer

This repository contains the required changes to the original DBpedia Spotlight
source code to be able to build your own DBpedia Spotlight for each language within
the OpeNER project.

The result will be the creation of a jar binary of the DBpedia Spotlight that takes
as argument a server_$lang.properties file with language specific configuration to run a rest
server of a DBpedia Spotlight for each language.

Developed by IXA NLP Group (ixa.si.ehu.es) for the 7th Framework OpeNER European project.

### Contents

The contents of the repository are the following:

- core: directory containing the core of the EHU DBpedia Spotlight
    + conf/ modified configuration files from the original DBpedia Spotlight
    + core/ modified source files from the original DBpedia Spotlight
    + install.bash script to install, modify, compile and create a binary of
      the original DBpedia Spotlight
    + pom.xml modified pom.xml to install DBpedia Spotlight

- README.md: This README


## Install and Modify dbpedia-spotlight for OpeNER NED

If you already have installed in your machine JDK7 and MAVEN 3, please go to step 3
directly. If you have already your Lucene-based disambiguation index for DBPedia Spotlight
ready and zipped as index-$lang.tgz, please go straight to step 4.
Otherwise, follow these steps:

### 1. Install JDK 1.7

If you do not install JDK 1.7 in a default location, you will probably need to configure the PATH in .bashrc or .bash_profile:

    export JAVA_HOME=/yourpath/local/java17
    export PATH=${JAVA_HOME}/bin:${PATH}


If you use tcsh you will need to specify it in your .login as follows:

    setenv JAVA_HOME /usr/java/java17
    setenv PATH ${JAVA_HOME}/bin:${PATH}


If you re-login into your shell and run the command

    java -version


You should now see that your jdk is 1.7

### 2. Install MAVEN 3

Download MAVEN 3 from

    wget http://ftp.udc.es/apache/maven/maven-3/3.0.4/binaries/apache-maven-3.0.4-bin.tar.gz


Now you need to configure the PATH. For Bash Shell:

    export MAVEN_HOME=/home/ragerri/local/apache-maven-3.0.4
    export PATH=${MAVEN_HOME}/bin:${PATH}

For tcsh shell:

    setenv MAVEN3_HOME ~/local/apache-maven-3.0.4
    setenv PATH ${MAVEN3}/bin:{PATH}

If you re-login into your shell and run the command

    mvn -version


You should see reference to the MAVEN version you have just installed plus the JDK 7 that is using.

### 3. Create Disambiguation Index

You will need to prepare the Disambiguation index following the instructions as specified in the
[Internationalization of DBpedia Spotlight for OpeNER](https://github.com/opener-project/EHU-DBpedia-Spotlight/wiki/DBpedia-Spotlight-Internationalization-for-OpeNER )

### 4. Get repository from github

    git clone git@github.com:opener-project/EHU-DBpedia-Spotlight.git
    cd EHU-DBpedia-Spotlight/core

### 5. Install and Modify DBpedia Spotlight for NED in OpeNER

From the EHU-DBpedia-Spotlight/core/ directory run:

    ./install.bash $lang index-$lang.tgz


Where lang is one of (de|en|es|fr|it|nl) and index-$lang.tgz is the tar gzipped Lucene-based
disambiguation index for DBpedia Spotlight generated as explained in step 3. above.

The install.bash script obtains the latest version of the DBpedia
Spotlight. It also performs the required modifications to be able to
run a version of DBpedia Spotlight for any desired language. These are
steps performed by the install.bash script:

#### 5.1 Download the dbpedia spotlight

   git clone https://github.com/dbpedia-spotlight/dbpedia-spotlight.git

The latest version of the dbpedia-spotlight is obtained and it is stored in the "dbpedia-spotlight" directory

#### 5.2 Modify some of the configuration files

It copies from EHU-DBpedia-spotlight to dbpedia-spotlight the following files:

     - pom.xml
     - core/pom.xml
     - conf/server_$lang properties, one for each language

Each server_$lang.properties files contain the necessary information to run a NED rest service for each language using
DBpedia Spotlight. Each server_$lang.properties has hard-coded the port to use. The port number range from 2010 to 2060
and are assigned by language code alphabetical order:

     - de: 2010
     - en: 2020
     - es: 2030
     - fr: 2040
     - it: 2050
     - nl: 2060

The port for each language needs to be given as argument to the [EHU-ned_kernel](https://github.com/opener-project/EHU-ned_kernel) module.

#### 5.3 Install the dbpedia spotlight

     cd dbpedia-spotlight
     mvn [clean] install

#### 5.4 Create a jar to run the dbpedia spotlight as a service

     cd dbpedia-spotlight/dist
     mvn clean package

This command creates (among others)

     dbpedia-spotlight-0.6-jar-with-dependencies.jar

**This jar contains every required dependency to run dbpedia-spotlight as a rest server.**


#### 5.5 Move index-$lang to data directory

The install.bash script needs to be passed the index-$lang.tgz as argument. This will be
moved and unzip to the data subdirectory:

     mkdir data
     tar xvzf index-$lang.tgz


### 6 Run the dbpedia-spotlight (modified for OpeNER) server

Before runing the server, verify that the dbpedia-spotlight directory contains:

       data/index-$lang directory
       dist/target/dbpedia-spotlight-0.6-jar-with-dependencies.jar

If something is missing, go step by step in the install.bash script.

Once everything is correct, go to the conf directory and **run the server**:

    cd dbpedia-spotlight/conf/
    java -jar ../dist/target/dbpedia-spotlight-0.6-jar-with-dependencies.jar server_$lang.properties


**Congratulations!!** You can now send queries to the running OpeNER dbpedia-spotlight server via the
[EHU-ned_kernel module](https://github.com/opener-project/EHU-ned_kernel).

#### Contact information

    Rodrigo Agerri and Itziar Aldabe
    {rodrigo.agerri,itziar.aldabe}@ehu.es
    IXA NLP Group
    University of the Basque Country (UPV/EHU)
    E-20018 Donostia-San Sebastián
