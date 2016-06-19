#!/bin/bash -x

MASTER_DIR=$1
TITLE_DIR=$2
BOOK_ID=$3
if [ "$NOTIFY_SLACK_WHEN_NOT_AVAILABLE" = "" ]; then
    NOTIFY_SLACK_WHEN_NOT_AVAILABLE="true"
fi

if [ "$MASTER_DIR" = "" ] || [ "$TITLE_DIR" = "" ] || [ "$BOOK_ID" = "" ] ; then
    echo "usage: ./`basename "$0"` MASTER_DIR TITLE_DIR BOOK_ID"
    echo "example: ./`basename "$0"` /media/master /media/title 123456"
    exit
fi

# script dir
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker run \
    -e LANG=C.UTF-8 \
    -v "$HOME/config":"/tmp/config":ro \
    -v "$DIR/src/main/resources":"/tmp/script":ro \
    -v "$MASTER_DIR/$BOOK_ID":"/tmp/input/$BOOK_ID":ro \
    -v "$TITLE_DIR":"/tmp/output" \
    -e NOTIFY_SLACK_WHEN_NOT_AVAILABLE=$NOTIFY_SLACK_WHEN_NOT_AVAILABLE \
    nlbdev/docker-nlb-base
