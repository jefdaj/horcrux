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
  export SECRET_TEXT='this could be some secret text'
  export SIGN_KEY_PASSWORD='testpass1'
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
expect "enter a password for the signing key: "; send "${SIGN_KEY_PASSWORD}\n"
expect "confirm password for the signing key: "; send "${SIGN_KEY_PASSWORD}\n"
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

@test "old test 03: sign" {
  cd "$HORCRUX_DIRNAME"
  echo "$SECRET_TEXT" > secret1.txt
  expect << END
set timeout 10
spawn horcrux sign sign.key secret1.txt
expect "enter a password to unlock sign.key: "
send -- "${SIGN_KEY_PASSWORD}\n"
expect eof
END
  assert_file_contains secret1.txt "$SECRET_TEXT" grep
  assert_file_contains secret1.txt.sig "END PGP SIGNATURE" grep
}
