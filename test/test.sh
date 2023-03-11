#!/usr/bin/env bash

# optional tmpdir. if none set it makes a random one
test_dir="$1"
[[ -z "$test_dir" ]] && test_dir="$(mktemp -d)"

echo "tests will be done in $test_dir"

export SRC_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export PATH="$SRC_DIR":$PATH

# run test scripts in order
for script in "$SRC_DIR"/test-*-*.sh; do
  cd "$test_dir"
  log_file="$(basename ${script/.sh/.txt})"

  echo -n "running $(basename $script)... "
  bash "$script" 2>&1 > "$log_file"; script_code=$?

  # fail if log contains any ERRORs
  grep ERROR "$log_file" && exit 1

  # fail if output doesn't exactly match the reference
  diff "${SRC_DIR}/${log_file}" "$log_file"
  if [[ $? -ne 0 ]]; then
    echo "ERROR: unexpected output"
    exit 1
  fi

  # fail if script exited non-zero
  [[ $script_code -ne 0 ]] && exit 1

  echo "ok"
done
