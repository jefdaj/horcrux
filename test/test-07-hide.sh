#!/usr/bin/env bash

export SRC_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cp "$SRC_DIR"/example.* ./

cd my-first-horcrux

expect << END
set timeout 10
spawn horcrux hide decrypt.key horcrux-01.key ../example.jpeg horcrux-01.jpeg
expect eof
END

expect << END
set timeout 10
spawn horcrux hide decrypt.key horcrux-02.key ../example.wav  horcrux-02.wav
expect eof
END

file *.jpeg *.wav
