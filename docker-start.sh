#!/bin/sh
set -eu
# Set ECHO_STORAGE=/var/echo when using a persistent Render disk.
STORAGE="${ECHO_STORAGE:-/app/storage}"
mkdir -p "$STORAGE/data" "$STORAGE/media"
for item in media_seed/*; do
  [ -f "$item" ] || continue
  target="$STORAGE/media/$(basename "$item")"
  [ -f "$target" ] || cp "$item" "$target"
done
ln -sfn "$STORAGE/data" data
ln -sfn "$STORAGE/media" media
exec ./echo_server
