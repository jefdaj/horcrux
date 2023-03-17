#!/usr/bin/env bash

leave_test_files=false
update_golden_logs=false

# apply optional cli flags
while getopts 'lu' opt; do
  case "$opt" in
    l) leave_test_files=true ;;
    u) update_golden_logs=true ;;
  esac
done

export SRC_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export PATH="$SRC_DIR":$PATH
export TEST_DIR="$(mktemp -d)"

rm_test_dir() { rm -r "$TEST_DIR"; }

if $leave_test_files; then
  echo "logs and misc test files will be left in $TEST_DIR"
else
  trap rm_test_dir EXIT
fi

if $update_golden_logs; then
  echo "golden logfiles in "$SRC_DIR" will be updated for passing tests"
fi

# run test scripts in order
for script in "$SRC_DIR"/test-*-*.sh; do
  cd "$TEST_DIR"
  log_name="$(basename ${script/.sh/.txt})"
  golden_file="${SRC_DIR}/${log_name}"

  echo -n "running $(basename $script)... "
  bash "$script" 2>&1 > "$log_name"; script_code=$?

  # fail if log contains any ERRORs
  grep ERROR "$log_name" && exit 1

  diff "$golden_file" "$log_name"
  diff_code=$?

  # fail if script exited non-zero or produced unexpected output
  [[ $script_code -ne 0 ]] && exit 1
  if [[ $diff_code -ne 0 && ! $update_golden_logs ]]; then
    echo "ERROR: unexpected output"
    exit 1
  fi

  # ...unless we're purposely updating the golden files
  if [[ $diff_code -ne 0 && $update_golden_logs ]]; then
    echo "updating '$golden_file'"
    cp "$log_name" "$golden_file"
  fi

  echo "ok"
done
