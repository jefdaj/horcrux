#!/usr/bin/env bash

export HORCRUX_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export PATH="$HORCRUX_DIR":$PATH

cd "$HORCRUX_DIR"/tests

for script in *.sh; do
  log_file="${script/.sh/.txt}"
  test_dir="${script/.sh/}"
  echo -n "running ${script}... "
  . "$script" 2>&1 > "$log_file" && echo "ok" || echo "ERROR"
done
