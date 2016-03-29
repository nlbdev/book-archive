#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

xgettext -L Python -d messages -o i18n/messages.pot *.py
for lang in $DIR/i18n/*/ ; do
    cd "$lang"/LC_MESSAGES
    msgmerge -N messages.po ../../messages.pot > messages.po.new 2>/dev/null && mv messages.po.new messages.po
    UNTRANSLATED_COUNT="`cat messages.po | grep 'msgstr ""' | wc -l`"
    if [ "$UNTRANSLATED_COUNT" != "0" ]; then
        echo
        echo "$UNTRANSLATED_COUNT untranslated strings for language '`echo $lang | sed 's/.*i18n\///' | sed 's/\/.*//'`':"
        echo
        cat messages.po | grep -B 1 'msgstr ""'
    fi
    msgfmt messages.po -o messages.mo
done
echo
