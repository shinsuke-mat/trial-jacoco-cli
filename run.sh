#!/bin/bash

JACOCO_VERSION=0.8.6

function init() {
    mkdir -p tmp
    
    if [ ! -d jacoco ]; then
        wget -O tmp/jacoco-$JACOCO_VERSION.zip http://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/$JACOCO_VERSION/jacoco-$JACOCO_VERSION.zip
        unzip tmp/jacoco-$JACOCO_VERSION.zip -d jacoco
    fi
}

init

echo '>> compiling java file'
javac -d tmp/orig Example.java

echo '>> jacoco instrumenting'
java -jar jacoco/lib/jacococli.jar instrument tmp/orig/Example.class --dest tmp/jacoco/

echo '>> executing instrumented class file'
java -cp "jacoco/lib/*;tmp/jacoco" Example

echo '>> generating execution report'
java -jar jacoco/lib/jacococli.jar report jacoco.exec --sourcefiles . --classfiles tmp/orig --html out

echo '>> open file://'$(pwd)'/out/index.html'
