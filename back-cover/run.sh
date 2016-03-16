#!/bin/bash -x

MASTER_DIR=$1
BACK_COVER_DIR=$2
BOOK_ID=$3

if [ "$MASTER_DIR" = "" ] || [ "$BACK_COVER_DIR" = "" ] || [ "$BOOK_ID" = "" ] ; then
    echo "usage: ./`basename "$0"` MASTER_DIR BACK_COVER_DIR BOOK_ID"
    echo "example: ./`basename "$0"` /media/master /media/back_cover 123456"
    exit
fi

# script dir
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker run \
    -e LANG=C.UTF-8 \
    -v "$HOME/config":"/tmp/config" \
    -v "$DIR/src/main/resources":"/tmp/script" \
    -v "$MASTER_DIR/$BOOK_ID":"/tmp/input/$BOOK_ID" \
    -v "$BACK_COVER_DIR":"/tmp/output" \
    nlbdev/docker-nlb-base
