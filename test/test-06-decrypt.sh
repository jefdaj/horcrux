#!/usr/bin/env bash

cd my-first-horcrux
rm secret1.txt

# should work with 3 or more keys
for n_keys in {1..5}; do
  rm -f secret-decrypted.txt
  keys="$(ls horcrux-*.key | shuf | head -n ${n_keys})"
  echo "trying to decrypt with ${n_keys} keys..."
  horcrux decrypt decrypt.key verify.key secret1.txt.gpg secret-decrypted.txt $keys
  exit_code=$?
  [[ $n_keys -lt 3 && $exit_code -ne 0 ]] && echo "(this is expected)"
  [[ $n_keys -lt 3 && $exit_code -eq 0 ]] && echo "ERROR: succeeded with $n_keys keys"
  [[ $n_keys -ge 3 && $exit_code -ne 0 ]] && echo "ERROR: failed with $n_keys keys"
  echo
done
