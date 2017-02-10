#!/bin/bash

# script to guess 'daps -d DC-...' command line from given xml filename
# usage: daps_cmdline.sh -f xml_file -d DC-file -t pdf -r rootid

while getopts f:dtr option
do
  case "${option}"
    in
    f) XMLFILE=${OPTARG};;
    d) DCFILE=${OPTARG};;
    t) TARGET=${OPTARG};;
    r) ROOTID=${OPTARG};;
  esac
done

# test if XMLFILE exists
#[ ! -f $XMLFILE ] && echo 'XMLFILE not found' >&2; exit 1;
#ROOTID=$(grep -oP ' (xml:)?id="([^"]+)"' "$1" | head -1 | sed -r 's/ (xml:)?id="(.+)"/\2/')

ROOTID=$(/usr/bin/xmlstarlet sel -T -N db="http://docbook.org/ns/docbook" \
  -t -v "//db:chapter/@xml:id" $XMLFILE)

DCFILE="DC-ses4-admin"
TARGET="html"

DAPS_CMDLINE="daps -d $DCFILE $TARGET --rootid=$ROOTID"

TARGET_PATH=$($DAPS_CMDLINE)

if [ "$TARGET" = "html" ]; then
  TARGET_PATH+="index.html"
fi

echo $TARGET_PATH

exit 0
