#!/usr/bin/env bash

cd my-first-horcrux
rm secret1.txt

# should work with 3 or more keys
for n_keys in {5..1}; do
  rm -f secret-decrypted.txt
  keys="$(ls horcrux-*.key | shuf | head -n ${n_keys})"
  echo "trying to decrypt with ${n_keys} keys..."
  horcrux decrypt decrypt.key verify.key secret1.txt.gpg secret-decrypted.txt $keys
  echo
done
