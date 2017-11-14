#!/usr/bin/env bash

# TODO explicitly name all the files (.asc etc)

set -e
rm -rf example
mkdir example
export PATH="$PWD":$PATH

say() { echo "$ # $1"; }
run() { echo "$ $1" && eval "$1" ; echo "$"; }

say "if you create keys for a 3-of-5 scheme"
run 'horcrux -v setup 3 5 example'

say "then encrypt a new file (aka update the secret)"
run "echo 'super secret message!' > example/secret.txt"
run 'horcrux -v encrypt example/{encrypt.key,sign.key,secret.txt,secret.txt.gpg}'

# TODO verify can be done separately
say "and distribute the verify and decrypt keys to trustees,"
say "along with a password share each,"
say "then they can each verify the signature"
run 'horcrux -v verify example/{verify.key,secret.txt.gpg}'

say "but with only 1 or 2 shares, they can't decrypt it"
set +e
run 'horcrux -v decrypt example/{decrypt.key,verify.key,secret.txt.gpg,secret-decrypt-with-keys.txt,share-{01,02}.key}'
set -e

say "3 shares are needed to get the password,"
say "which is needed to get the decrypt key, which is needed to get the secret"
run 'horcrux -v decrypt example/{decrypt.key,verify.key,secret.txt.gpg,secret-decrypt-with-keys.txt,share-{01,04,05}.key}'

say "optionally, you can hide keys in images or sound files"
run "horcrux -v hide example/decrypt.key example/share-01.key example.jpeg example/share-01.jpeg"

say "the hidden files can be unhidden individually"
run "horcrux -v unhide example/{decrypt.key,share-01.jpeg,share-01-unhidden.key}"

say "or it will be done automatically during decryption"
run 'horcrux -v decrypt example/{decrypt.key,verify.key,secret.txt.gpg,secret-decrypt-with-jpeg.txt,share-01.jpeg,share-{02,04}.key}'

# wart: delete duplicate shares because they mess up password reconstruction
#       (only a problem when mixing advanced cli args with autodecrypt)
rm example/{*-unhidden.key,*.jpeg}

say "autoverify and autodecrypt modes will look for files"
say "in the given directory (default: .), making it possible"
say "to launch horcrux by dropping a folder on the .desktop file"
run "horcrux autoverify example"
run "horcrux -v autodecrypt example"

say "final files:"
run 'ls example'
run 'cat example/secret*.txt'
