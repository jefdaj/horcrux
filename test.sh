#!/usr/bin/env bash

export HORCRUX_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export PATH="$HORCRUX_DIR":$PATH

cd "$HORCRUX_DIR"/tests

# run test scripts in order
for script in *.sh; do
  log_file="${script/.sh/.txt}"
  echo -n "running ${script}... "
  . "$script" 2>&1 > "$log_file" && echo "ok" || echo "ERROR"
done

# remove test dirs at the end rather than one at a time,
# so they can use each others' output
find * -type d | xargs rm -r
