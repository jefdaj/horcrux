#!/usr/bin/env bats

# TODO how to get this to execute inside `nix develop` shell or similar?

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  # TODO ensure nix build first?
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  PATH="$DIR/../result/bin:$PATH"
  echo "PATH: $PATH"
}

@test "python3 dependency installed" {
  run 'python3 --version'
  assert_output 'Python 3.12.12'
}

@test "steghide dependency installed" {
  run 'steghide --version'
  assert_output 'steghide version pre0.5.2'
}

@test "ssss dependency installed" {
  run 'ssss-split'
  assert_output -p "Split secrets using Shamir's Secret Sharing Scheme."
}

@test "prints usage if no args" {
  run horcrux
  assert_output -p "Usage:"
}
