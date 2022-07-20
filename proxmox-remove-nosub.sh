#!/bin/sh
#
# MIT License


FIND="NotFound"
ACTIVE="Active"
FILE=/usr/share/perl5/PVE/API2/Subscription.pm
ARG="$1"

apply_remove() {
  sed -i "s/$FIND/$ACTIVE/g" "$FILE"
  echo "restarting services..."
  systemctl restart pvedaemon
  systemctl restart pveproxy
  echo "success: subscription updated from: $FIND to $ACTIVE"
}

echo "attempting pve-no-subscription patch"

if ! [ -n "$ARG" ]; then
  if ! test -f "$FILE"; then
    echo "$FILE does not exist! are you sure this is pve?"
    exit 0
  fi

  if ! grep -i "$FIND" "$FILE"; then
    echo "pve appears to be patched."
    exit 0
  fi
fi

echo "attempting replacement in $FILE..."
apply_remove
