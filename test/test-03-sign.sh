#!/usr/bin/env bash

cd my-first-horcrux
echo "this could be some secret text" > secret1.txt
expect << END
set timeout 10
spawn horcrux sign sign.key secret1.txt
expect "enter a password to unlock sign.key: "
send -- "testpass1\n"
expect eof
END
sync
wc -l secret1.txt*
