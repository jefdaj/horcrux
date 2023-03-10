#!/usr/bin/env bash

cd my-first-horcrux
expect << END
set timeout 10
spawn horcrux encrypt encrypt.key sign.key secret1.txt secret1.txt.gpg
expect "enter a password to unlock sign.key: "
send -- "testpass1\n"
expect eof
END
sync
echo
file secret1.txt*
