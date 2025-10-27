#!/bin/bash

set -e

PUB_DIR=${PUB_DIR:-../korpiq.github.io}
NAME=$(cd build && echo *.d64 | sed 's/\.d64$//')
CUSTOM_VERSION=${VERSION:-}
VERSION=${VERSION:-$(cat version.txt)}
TITLE="cbm64-flight-v$VERSION"
POST="_posts/$(date -I)-$TITLE.markdown"
RUN_LINK="https://vc64web.github.io/#openROMS=true#port2=true#https://korpiq.github.io"
NOW=$(date -Is)

if [ -e "$PUB_DIR/$POST" ]
then
    echo >&2 "Already published: $PUB_DIR/$POST"
    exit 1
fi

FILES=$(cd build; ls *.{prg,d64})
PUB_FILES=""
for FILE in $FILES
do
    PUB_FILE="$(sed "s/\./-v$VERSION./" <<<"$FILE")"
    cp -v "build/$FILE" "$PUB_DIR/cbm64/$PUB_FILE"
    PUB_FILES="$PUB_FILES $PUB_FILE"
done

cd "$PUB_DIR"

cat > "$POST" <<__POST__
---
layout: post
title:  "$TITLE"
date:   $NOW
categories: cbm64 games
---

Airplane game for 4 players on Commodore 64

$(
    for PUB_FILE in $PUB_FILES
    do
        if grep -q '\.prg$' <<<"$PUB_FILE"
        then
            echo "- Try it out with cursor keys as joystick at [$RUN_LINK{% link /cbm64/$PUB_FILE %}]($RUN_LINK{% link /cbm64/$PUB_FILE %})"
        else
            echo "- Playable disk image: [{% link /cbm64/$PUB_FILE %}]({% link /cbm64/$PUB_FILE %})"
        fi
    done
)
- Source [https://github.com/korpiq/cbm64-flight](https://github.com/korpiq/cbm64-flight)
- Version $VERSION published at $NOW

__POST__

./build.sh

git add cbm64 _site "$POST"
git commit -m "published $TITLE"

git push

cd -

[ -n "$CUSTOM_VERSION" ] ||
    perl -wi -pe 's/^(\d+\.\d+\.)(\d+).*/$1 . (1 + $2)/e' version.txt # bump to next patch to avoid repeat, let me fix manually later
