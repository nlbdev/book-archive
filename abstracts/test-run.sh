#!/bin/bash
set -e

BOOK_ID="$1"
if [ "$BOOK_ID" = "" ]; then
    BOOK_ID="1001"
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -d "$DIR/target/book-archive" ]; then
    echo
    echo "Test book directory not present; will download DAISY 2.02 audio books from daisy.org/sample-content as well as books from ./test-books"
    echo
    mkdir -p "$DIR/target"
    wget "http://www.daisy.org/samples/3full-text-full-audio/1Brochure-DAISY-Consortium.zip" -O "$DIR/target/1001.zip"
    wget "http://www.daisy.org/samples/202full-text-full-audio/fire-safety.zip" -O "$DIR/target/1002.zip"
    wget "http://www.daisy.org/samples/202full-text-full-audio/gon-ruby-mp3.zip" -O "$DIR/target/1003.zip"
    #wget "http://www.daisy.org/samples/202full-text-full-audio/frontpage-202-complete.zip" -O "$DIR/target/1004.zip"
    wget "http://www.daisy.org/samples/202full-text-full-audio/valentin-hauy.zip" -O "$DIR/target/1005.zip"
    mkdir -p "$DIR/target/book-archive/1001" && unzip "$DIR/target/1001.zip" -d "$DIR/target/book-archive/1001/"
    mkdir -p "$DIR/target/book-archive/1002" && unzip "$DIR/target/1002.zip" -d "$DIR/target/book-archive/1002/"
    mkdir -p "$DIR/target/book-archive/1003" && unzip "$DIR/target/1003.zip" -d "$DIR/target/book-archive/1003/"
    #mkdir -p "$DIR/target/book-archive/1004" && unzip "$DIR/target/1004.zip" -d "$DIR/target/book-archive/1004/"
    mkdir -p "$DIR/target/book-archive/1005" && unzip "$DIR/target/1005.zip" -d "$DIR/target/book-archive/1005/"
    mkdir "$DIR/target/out"
fi

docker run \
    -e LANG=C.UTF-8 \
    -v "$HOME/config":"/tmp/config" \
    -v "$DIR/target/book-archive/$BOOK_ID":"/tmp/input/$BOOK_ID" \
    -v "$DIR/target/output":"/tmp/output" \
    -v "$DIR/src/main/resources":"/tmp/script" \
    nlbdev/docker-nlb-base
