#!/bin/bash
set -e

BOOK_ID="$1"
if [ "$BOOK_ID" = "" ]; then
    BOOK_ID="612923"
fi

function make_empty_mp3s(){
    if ! [ -x "$(command -v perl)" ]; then echo 'perl is not installed.' >&2 ; exit ; fi
    if ! [ -x "$(command -v sox)" ]; then echo 'sox is not installed.' >&2 ; exit ; fi
    if ! [ -x "$(command -v lame)" ]; then echo 'lame is not installed.' >&2 ; exit ; fi
    BOOKDIR="$1"
    MP3s="$1/*.mp3.*"
    for mp3 in $MP3s
    do
        LENGTH="`echo $mp3 | sed 's/.*\.//'`"
        FILENAME="`echo $mp3 | sed 's/\.mp3\.[0-9]*$//i' | sed 's/.*\///'`"
        echo "Inflating empty MP3 file: $FILENAME.mp3 ($LENGTH seconds)"
        perl "$DIR/test-books/silence.pl" $LENGTH "/tmp/$FILENAME.wav"
        lame "/tmp/$FILENAME.wav" "$BOOKDIR/$FILENAME.mp3"
        rm "$mp3" "/tmp/$FILENAME.wav"
    done
}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -d "$DIR/target/book-archive" ]; then
    echo
    echo "Test book directory not present; will populate with books from ./test-books"
    echo
    mkdir -p "$DIR/target"
    cp -r "$DIR/test-books/612923" "$DIR/target/book-archive/" && make_empty_mp3s "$DIR/target/book-archive/612923"
    cp -r "$DIR/test-books/613629" "$DIR/target/book-archive/" && make_empty_mp3s "$DIR/target/book-archive/613629"
    cp -r "$DIR/test-books/618985" "$DIR/target/book-archive/" && make_empty_mp3s "$DIR/target/book-archive/618985"
    cp -r "$DIR/test-books/623556" "$DIR/target/book-archive/" && make_empty_mp3s "$DIR/target/book-archive/623556"
    mkdir "$DIR/target/out"
fi

docker run \
    -e LANG=C.UTF-8 \
    -v "$HOME/config":"/tmp/config" \
    -v "$DIR/target/book-archive/$BOOK_ID":"/tmp/input/$BOOK_ID" \
    -v "$DIR/target/output":"/tmp/output" \
    -v "$DIR/src/main/resources":"/tmp/script" \
    nlbdev/docker-nlb-base
