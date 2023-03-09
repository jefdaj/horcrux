#!/usr/bin/env bash

export HORCRUX_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export PATH="$HORCRUX_DIR":$PATH

cd "$HORCRUX_DIR"/tests

# run test scripts in order
for script in *.sh; do
  log_file="$PWD/${script/.sh/.txt}"
  echo -n "running ${script}... "
  . "$script" 2>&1 > "$log_file"; exit_code=$?
  grep ERROR "$log_file"; grep_code=$?
  [[ $grep_code -ne 0 && $exit_code -eq 0 ]] && echo "ok" || break
  cd "$HORCRUX_DIR"/tests
  sleep 1
done

# remove test dirs at the end rather than one at a time,
# so they can use each others' output
cd "$HORCRUX_DIR"
# find tests/* -maxdepth 1 -type d | xargs rm -rf
# git diff tests
