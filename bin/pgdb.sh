#!/bin/sh

# pgdb.sh: Run a development instance of postgres locally.
#
# Starts postgres with all data in the specified folder. Uses the nix package
# manager if available and no `postgres` is found in PATH. Creates a database
# "dev", uses the local username as the super user.

# Copyright (c) 2020 Marc Brinkmann

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

set -e
set -x

NIX_POSTGRES_PACKAGE=postgresql_11

if [ x"$PGDB_TRY_NIX" = "x1" ]; then
  if ! which nix-shell > /dev/null; then
    echo 'Did not find `nix-shell` on path and PGDB_TRY_NIX is set, giving up'
    exit 1
  fi

  export PGDB_TRY_NIX=2
  exec nix-shell -p $NIX_POSTGRES_PACKAGE --run "$0 $*"
fi

if ! which postgres > /dev/null; then
  if [ x"$PGDB_TRY_NIX" = "x2" ]; then
    echo "Tried nix, didn't work, giving up";
    exit 1;
  fi;
  echo 'Did not find `postgres` on path, trying again with nix-shell'
  export PGDB_TRY_NIX=1
  exec $0 $*
fi

echo "PostgreSQL: $(which postgres)"

if [ $# != 1 ]; then
  echo "usage: $(basename $0) PATH_TO_DB"
  exit 1
fi;

DB=$1
ADMIN_USER=$(whoami)
DBNAME=dev
DEV_USER=dev
SOCKET=$(readlink -f $DB)
export PGHOST=$SOCKET

if [ ! -e $DB ]; then
  echo "Creating new database in $DB, with $ADMIN_USER as the admin"

  # Create cluster
  initdb --no-locale --auth=trust -U $(whoami) -E UTF8 --nosync --pgdata $DB

  # Initialize with script
  pg_ctl -D $DB -o "-k $SOCKET" start
  psql -U ${ADMIN_USER} -d postgres -c "CREATE ROLE ${DEV_USER} LOGIN;"
  psql -U ${ADMIN_USER} -d postgres -c "CREATE DATABASE ${DBNAME} OWNER ${DEV_USER};"
  pg_ctl -D $DB stop
fi;

if [ ! -d $DB ]; then
  echo $DB exists, but is not a directory
  exit 1
fi;

echo "You can now connect using either:"
echo -e "\e[33mPGHOST=${PGHOST}\e[39;49m"
echo -e "\e[33mDATABASE_URL=\"postgres://${DEV_USER}@127.0.0.1/${DBNAME}\"\e[39;49m"
postgres -D $SOCKET -k $SOCKET

