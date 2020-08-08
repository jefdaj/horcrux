#!/usr/bin/env bash

mkdir lost-keys
mv my-first-horcrux/horcrux-* lost-keys/
rm -f my-first-horcrux/secret1.txt.sig my-first-horcrux/secret-decrypted.txt

# should work with 3 or more keys
for n_keys in {1..5}; do
  echo "trying to decrypt with ${n_keys} keys... "
  cp -r my-first-horcrux with-${n_keys}-keys
  k=1
  while [[ $k -le $n_keys ]]; do
    cp lost-keys/horcrux-*${k}.key* with-${n_keys}-keys
    k=$((k+1))
  done
  horcrux autodecrypt with-${n_keys}-keys
  echo
done
