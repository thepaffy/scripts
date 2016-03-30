#!/bin/bash

# Folder for gluon
GLUONDIR=/opt/builds/gluon
# The gluon branch
GLUONBRANCH=v2016.1.x
# Gluon target
TARGET=ar71xx-generic
# Site directory
SITEDIR=/home/thepaffy/ffww/sites/neuwied
# Release name
RELEASE=3.1-paffy
# Gluon branch
BRANCH=experimental
# The promote directory. The script will copy the builded images to thar directory.
# Leave empty, if not needed.
PROMOTEDIR=

echo "GLUONDIR:    $GLUONDIR"
echo "GLUONBRANCH: $GLUONBRANCH"
echo "TARGET:      $TARGET"
echo "SITEDIR:     $SITEDIR"
echo "RELEASE:     $RELEASE"
echo "BRANCH:      $BRANCH"
echo "PROMOTEDIR:  $PROMOTEDIR"

# fetch sites
echo "--- fetch sites ---"
if [ ! -d "$SITEDIR" ]; then
    git clone git@github.com:FreifunkWesterwald/sites.git $SITEDIR
else
    cd $SITEDIR
	git pull
fi

# set environment variabels
export GLUON_SITEDIR=$SITEDIR
export GLUON_RELEASE=$RELEASE
export GLUON_BRANCH=$BRANCH

# fetch gluon
echo "--- fetch gluon ---"
if [ ! -d "$GLUONDIR" ]; then
    git clone https://github.com/freifunk-gluon/gluon.git $GLUONDIR -b $GLUONBRANCH
    cd $GLUONDIR
else
    cd $GLUONDIR
    make clean GLUON_TARGET=$TARGET
    git pull
fi

# fetch dependencies
echo "--- fetch dependencies ---"
make update

# build gluon
echo "--- build gluon ---"
make GLUON_TARGET=$TARGET -j6

# promote build
echo "--- promote build ---"
if [ ! -z "$PROMOTEDIR" ]; then
    if [ ! -d "$PROMOTEDIR" ]; then
        mkdir -p $PROMOTEDIR
    fi
    cp -rL output/images $PROMOTEDIR
fi
