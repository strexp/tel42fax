#!/bin/bash

FAXTTY=${1:ttyIAX1}

while true; do

tmpdir=$(mktemp -d)

efax -d "/dev/$FAXTTY" \
  -w -s -iS0=2 \
  -r "$tmpdir/%y%m%d-%H%M%S.tiff" \
  >> "/var/log/efax/$FAXTTY.log" 2>&1

if [ -n "$(ls -A "$tmpdir" 2>/dev/null)" ]; then
  mkdir -p /var/spool/fax/incoming
  tiffcp $(find $tmpdir/* | xargs) "$tmpdir/results.tiff"
  tiff2pdf "$tmpdir/results.tiff" -o "/var/spool/fax/incoming/$(date "+%y%m%d-%H%M%S").pdf"
fi

rm -r "$tmpdir"

done
