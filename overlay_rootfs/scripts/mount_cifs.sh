#!/bin/sh

LOCKFILE=/tmp/mount_cifs.lock
HACK_INI=/tmp/hack.ini
STORAGE_CIFS=$(awk -F "=" '/STORAGE_CIFS *=/ {print $2}' $HACK_INI)
STORAGE_CIFSSERVER=$(awk -F "=" '/STORAGE_CIFSSERVER *=/ {gsub(/\/$/, "", $2); print $2}' $HACK_INI)
STORAGE_CIFSUSER=$(awk -F "=" '/STORAGE_CIFSUSER *=/ {print $2}' $HACK_INI)
STORAGE_CIFSPASSWD=$(awk -F "=" '/STORAGE_CIFSPASSWD *=/ {print $2}' $HACK_INI)

if [ "$STORAGE_CIFS" = "on" -o "$STORAGE_CIFS" = "alarm" -o "$STORAGE_CIFS" = "record" ] && [ "$STORAGE_CIFSSERVER" != "" ]; then
  # mount | grep "$STORAGE_CIFSSERVER" > /dev/null && exit
  while [ -f $LOCKFILE ] ; do
    sleep 0.5
  done
  # mount | grep "$STORAGE_CIFSSERVER" > /dev/null && exit
  umount -f /atom/mnt
  touch $LOCKFILE
  for VER in 2.0 2.1 3.0
  do
    if mount -t cifs -ousername=$STORAGE_CIFSUSER,password=$STORAGE_CIFSPASSWD,vers=$VER $STORAGE_CIFSSERVER /atom/mnt ; then
      rm -f $LOCKFILE
      exit 0
    fi
  done
  rm -f $LOCKFILE
fi
exit -1
