#!/bin/bash

function assertSuccess(){
        if [ $? -ne 0 ]; then echo "failed to checkout $TAG" && exit 1; fi
}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -d "$DIR/target/book-archive" ]; then
    echo
    echo "Test book directory not present; will download DAISY 2.02 audio books from daisy.org/sample-content"
    echo
    mkdir -p "$DIR/target"
    wget "http://www.daisy.org/samples/3full-text-full-audio/1Brochure-DAISY-Consortium.zip" -O "$DIR/target/1001.zip" ; assertSuccess
    wget "http://www.daisy.org/samples/202full-text-full-audio/fire-safety.zip" -O "$DIR/target/1002.zip" ; assertSuccess
    wget "http://www.daisy.org/samples/202full-text-full-audio/gon-ruby-mp3.zip" -O "$DIR/target/1003.zip" ; assertSuccess
    #wget "http://www.daisy.org/samples/202full-text-full-audio/frontpage-202-complete.zip" -O "$DIR/target/1004.zip" ; assertSuccess
    wget "http://www.daisy.org/samples/202full-text-full-audio/valentin-hauy.zip" -O "$DIR/target/1005.zip" ; assertSuccess
    mkdir -p "$DIR/target/book-archive/1001" && unzip "$DIR/target/1001.zip" -d "$DIR/target/book-archive/1001/"
    mkdir -p "$DIR/target/book-archive/1002" && unzip "$DIR/target/1002.zip" -d "$DIR/target/book-archive/1002/"
    mkdir -p "$DIR/target/book-archive/1003" && unzip "$DIR/target/1003.zip" -d "$DIR/target/book-archive/1003/"
    #mkdir -p "$DIR/target/book-archive/1004" && unzip "$DIR/target/1004.zip" -d "$DIR/target/book-archive/1004/"
    mkdir -p "$DIR/target/book-archive/1005" && unzip "$DIR/target/1005.zip" -d "$DIR/target/book-archive/1005/"
    mkdir "$DIR/target/out"
fi

BOOK_ID="1001"
docker run \
    -v "$DIR/target/book-archive/$BOOK_ID":"/tmp/input/$BOOK_ID" \
    -v "$DIR/target/output":"/tmp/output" \
    -v "$DIR/src/main/resources":"/tmp/script" \
    nlbdev/docker-nlb-base
