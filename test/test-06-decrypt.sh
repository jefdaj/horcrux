#!/usr/bin/env bash

cd my-first-horcrux
rm secret1.txt

threshold=3

echo "decrypt should succeed only with ${threshold}+ keys:"
echo

for n_keys in {1..5}; do
  rm -f secret-decrypted.txt
  keys="$(ls horcrux-*.key | shuf | head -n ${n_keys})"
  echo "trying to decrypt with ${n_keys} keys..."
  horcrux decrypt decrypt.key verify.key secret1.txt.gpg secret-decrypted.txt $keys
  exit_code=$?
  [[ $n_keys -lt $threshold && $exit_code -eq 0 ]] && echo "ERROR: succeeded with $n_keys keys"
  [[ $n_keys -ge $threshold && $exit_code -ne 0 ]] && echo "ERROR: failed with $n_keys keys"
  [[ $n_keys -lt $threshold && $exit_code -ne 0 ]] && echo "test passed"
  [[ $n_keys -ge $threshold && $exit_code -eq 0 ]] && echo "test passed"
  echo
done
