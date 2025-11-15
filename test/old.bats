# rewrite old tests 1-1 in bats
# usage:
#   bats test
#   BATSLIB_TEMP_PRESERVE=1 bats test

setup_file() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-file/load'

  export TEST_TEMP_DIR="$(temp_make)"

  # TODO is this where common vars go?
  export N_SHARES_THRESHOLD=3
  export N_SHARES_TOTAL=5
  export HORCRUX_DIRNAME='my-first-horcrux'
}

teardown_file() {
  # TODO how safe is this?
  temp_del "$TEST_TEMP_DIR"
}

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load 'test_helper/bats-file/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  PATH="$DIR/../result/bin":$PATH
  cd "$TEST_TEMP_DIR"
}

@test "old test 01: help" {
  run horcrux -h
  assert_output -p "Horcrux: immortality for your encrypted backups"
  assert_output -p "Usage:"
}

@test "old test 02: setup" {

  expect << END
set timeout 10
spawn horcrux setup $N_SHARES_THRESHOLD $N_SHARES_TOTAL $HORCRUX_DIRNAME
expect "enter up to 64 alphanumeric chars to mix in to the master password: "
send "0r9epwi;tkqwupuoi;qer]asdf\n"
expect "enter a password for the signing key: "; send "testpass1\n"
expect "confirm password for the signing key: "; send "testpass1\n"
expect eof
END

  for key_name in encrypt decrypt sign verify; do 
    assert_exists "${HORCRUX_DIRNAME}/${key_name}.key"
  done

  for share_n in $(seq 1 "$N_SHARES_TOTAL"); do
    share_n_padded="$(printf "%02d\n" $share_n)"
    share_path="${HORCRUX_DIRNAME}/horcrux-${share_n_padded}.key"
    assert_exists "$share_path"
    assert_exists "${share_path}.sig"
  done
}
