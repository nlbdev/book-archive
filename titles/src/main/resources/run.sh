#!/bin/bash
set -x
# This script finds a DAISY 2.02 book in /tmp/input/{bookid}/,
# and extracts an mp3 containing the book title into /tmp/output/{bookid}.mp3
# The ncc must have an element with class="title" for the script to be able to find the mp3.



# format_time: convert from smil time to (minutes).(seconds).(hundreths of a second) with zero-padded seconds and hundreths of a second
#
# handles input:
#     npt="[0-9]+\.[0-9]+s
#     npt="[0-9]+s
function format_time {
    CLIP="$1"
    
    SEC="`echo "$CLIP" \
        | sed 's/npt=//' \
        | sed 's/^\([0-9]\+\)s\?$/\1.00s/' \
        | sed 's/s$//'`00"
    
    echo "`calc "floor($SEC / 60)" | sed 's/^\s*//'`.`calc "floor($SEC % 60)" | sed 's/^\s*/0/' | sed 's/.*\([0-9][0-9]\)$/\1/'`.`echo "$SEC" | sed 's/^.*\.\([0-9][0-9]\).*/\1/'`"
}



# determine book id
BOOK_ID="`ls /tmp/input | head -n 1`"

# find ncc
NCC="`find -L /tmp/input | grep -i ncc.html`"
cd "`echo "$NCC" | sed 's/\/[^\/]*$//'`"
NCC="`echo "$NCC" | sed 's/.*\///'`"

# find smil reference in ncc
SMIL="`cat "$NCC" | tr -d "\n" | sed 's/^.*\?class="title"/class="title"/' | grep 'class="title"' | sed 's/</\n</g' | grep href | head -n 1 | sed 's/.*href="//' | sed 's/".*//'`"
if [ "$SMIL" = "" ]; then
    echo "Title was not found for $BOOK_ID"
    exit
fi
SMIL_HREF="`echo "$SMIL" | sed 's/#.*//'`"
SMIL_ID="`echo "$SMIL" | sed 's/.*#//'`"

# find mp3 reference in smil
MP3_HREF="`cat "$SMIL_HREF" | tr -d "\n" | sed "s/^.*\?id=\"$SMIL_ID\"//" | sed 's/<\/\(seq\|par\).*//' | sed 's/</\n</g' | grep '<audio' | head -n 1 | sed 's/.*src="//' | sed 's/".*//'`"

# get audio
MP3_LENGTH="`mp3info -p "%S\n" "$MP3_HREF"`"
if [ "$MP3_LENGTH" -lt 60 ]; then
    echo "$MP3_HREF is less than a minute; just use the whole mp3, it probably only contains the title"
    cp "$MP3_HREF" "/tmp/output/$BOOK_ID.mp3"
    
else
    echo "$MP3_HREF is more than 60 seconds long; let's split it at @clip-begin and @clip-end"
    MP3_CLIP_BEGIN="`cat "$SMIL_HREF" | tr -d "\n" | sed "s/^.*\?id=\"$SMIL_ID\"//" | sed 's/<\/\(seq\|par\).*//' | sed 's/</\n</g' | grep '<audio' | head -n 1 | sed 's/.*clip-begin="//' | sed 's/".*//'`"
    MP3_CLIP_END="`cat "$SMIL_HREF" | tr -d "\n" | sed "s/^.*\?id=\"$SMIL_ID\"//" | sed 's/<\/\(seq\|par\).*//' | sed 's/</\n</g' | grep '<audio' | tail -n 1 | sed 's/.*clip-end="//' | sed 's/".*//'`"
    MP3_CLIP_BEGIN="`format_time "$MP3_CLIP_BEGIN"`"
    MP3_CLIP_END="`format_time "$MP3_CLIP_END"`"
    
    mp3splt "$MP3_HREF" -o "/tmp/output/$BOOK_ID" "$MP3_CLIP_BEGIN" "$MP3_CLIP_END"
    chmod 666 "/tmp/output/$BOOK_ID.mp3"
fi

if [ ! -e "/tmp/output/$BOOK_ID.mp3" ]; then
    touch "/tmp/output/$BOOK_ID.mp3.missing"
    chmod 666 "/tmp/output/$BOOK_ID.mp3.missing"
fi
