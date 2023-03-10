#!/usr/bin/env bash

cd my-first-horcrux

expect << END
set timeout 10
spawn horcrux hide decrypt.key horcrux-01.key ../../assets/example.jpeg horcrux-01.jpeg
expect eof
END

expect << END
set timeout 10
spawn horcrux hide decrypt.key horcrux-02.key ../../assets/example.wav  horcrux-02.wav
expect eof
END

file *.jpeg *.wav
