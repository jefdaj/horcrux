setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  PATH="$DIR/../result/bin":$PATH
}

@test "prints usage if no args" {
  run horcrux
  assert_output -p "Usage:"
}
