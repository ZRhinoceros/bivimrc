#!/bin/bash

#main
if [ $# -ne 1 ];then
    echo "BAD Parameter!!!"
    return -1
fi

PLUG_HOME=$1
PLUG_NAME=nerdcommenter
PLUG_SUFFIX=tar.gz
PLUG_TARBALL="$PLUG_NAME.$PLUG_SUFFIX"

mkdir -p "$PLUG_HOME/$PLUG_NAME"
tar xzf $PLUG_TARBALL -C "$PLUG_HOME/$PLUG_NAME"

return $?
