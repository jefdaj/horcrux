#!/usr/bin/env bats

# TODO is this a bad idea?
# setup_file() {
#   nix build
# }

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  PATH="$DIR/../result/bin":$PATH
}

@test "correct python3 installed" {
  run python3 --version
  assert_output 'Python 3.12.12'
}

@test "correct steghide installed" {
  run steghide --version
  assert_output 'steghide version pre0.5.2'
}

@test "correct ssss installed" {
  run ssss-split
  assert_output -p "Split secrets using Shamir's Secret Sharing Scheme."
}

@test "prints usage if no args" {
  run horcrux
  assert_output -p "Usage:"
}
