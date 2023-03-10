#!/usr/bin/env bash

expect << END
set timeout 10
spawn horcrux setup 3 5 my-first-horcrux
expect "enter up to 64 alphanumeric chars to mix in to the master password: "
send "0r9epwi;tkqwupuoi;qer]asdf\n"
expect "enter a password to shield the signing key: "; send "testpass1\n"
expect "confirm password to shield the signing key: "; send "testpass1\n"
expect eof
END

echo
wc -l my-first-horcrux/*
