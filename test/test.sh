#!/usr/bin/env bash

# optional tmpdir. if none set it makes a random one
test_dir="$1"
[[ -z "$test_dir" ]] && test_dir="$(mktemp -d)"

export SRC_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export PATH="$SRC_DIR":$PATH

# run test scripts in order
# TODO pushd and popd here?
for script in "$SRC_DIR"/test-*-*.sh; do
  cd "$test_dir"
	log_file="$(basename ${script/.sh/.txt})"
	echo -n "running $(basename $script)... "
  bash "$script" 2>&1 > "$log_file"; script_code=$?
  grep ERROR "$log_file" && break || true
  [[ $script_code == 0 ]] && echo "ok" || break
done

# remove test dirs at the end rather than one at a time,
# so they can use each others' output
# cd "$SRC_DIR"
# find tests/* -maxdepth 1 -type d | xargs rm -rf
# git diff tests
