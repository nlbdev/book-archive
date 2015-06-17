#!/bin/bash

BUILDID="`docker build . | tail -n 1 | sed 's/.* //'`"
docker run -v "`pwd`/src/test/resources":"/book" -v "`pwd`/target/out":"/abstract" "$BUILDID" "$@"
