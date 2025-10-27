#!/bin/bash

set -e

PUB_DIR=${PUB_DIR:-../korpiq.github.io}
NAME=$(cd build && echo *.d64 | sed 's/\.d64$//')

cp build/*.{prg,d64} "$PUB_DIR/cbm64"

cd "$PUB_DIR"

./build.sh

git add cbm64 _site/cbm64
git commit -m "published $NAME"

git push
