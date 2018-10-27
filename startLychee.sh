#!/bin/sh

set -e

mkdir -p $UPLOAD_DIR/big
mkdir -p $UPLOAD_DIR/thumb
mkdir -p $UPLOAD_DIR/import
chown -R www-data:www-data $DATA_DIR
chown -R www-data:www-data $UPLOAD_DIR

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
