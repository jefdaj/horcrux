# rewrite old tests 1-1 in bats
# TODO can they be run sequentially as a single "scenario"?

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  PATH="$DIR/../result/bin":$PATH
}

@test "old test 01: help" {
  run horcrux -h
  assert_output -p "Horcrux: immortality for your encrypted backups"
  assert_output -p "Usage:"
}

@test "old test 02: setup" {
  expect << END
set timeout 10
spawn horcrux setup 3 5 my-first-horcrux
expect "enter up to 64 alphanumeric chars to mix in to the master password: "
send "0r9epwi;tkqwupuoi;qer]asdf\n"
expect "enter a password for the signing key: "; send "testpass1\n"
expect "confirm password for the signing key: "; send "testpass1\n"
expect eof
END
}
