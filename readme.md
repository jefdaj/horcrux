Horcrux
=======

Signed, updatable secrets unlocked by N of M optionally hidden keys.

Depending how you distribute the password shares, it can be used to create
a will or to backup your secret encryption keys. Or both at once!

The basic idea is:

1. Generate a master password for reading the secret,
   and break it into shares using [Shamir's secret sharing scheme][1].

2. Generate a gpg keypair and lock the private key with the master password.

3. Destroy the master password.

4. Keep the public key for updating the will, and distribute the locked private
   key + password shares to friends/family/yourself for unlocking it.

5. Generate a second gpg keypair and sign the encrypted secret with the second
   private key. Distribute the public key for signature checking.

After some initial setup on your end, verification + decryption should be as
simple as putting enough key shares in the proper directory and dragging it
onto the `.desktop` launchers. Suitable for advanced parents!

Install
-------

Horcrux should work anywhere you can install the following apt dependencies or
their equivalents:

* gnupg
* pwgen
* python 2.7
* python-docopt
* python-gnupg
* ssss
* steghide

You need root access for steghide, but only if you want to hide keyshares in
images or audio files. To avoid persistent logs or tempfiles I recommend
booting into [TAILS][2] or another linux live system.

Setup
-----

Run `horcrux create` with the number of keys to unlock and total keys. It'll
generate these files:

* `update.key` for updating the will (keep this)
* `sign.key` for signing the updated will (keep this)
* `verify.key` for checking the signature (distribute this)
* multiple `unlock-XX.key` shares for unlocking the will (distibute and/or keep these)
* `decrypt.key` for decrypting (distribute this; it's locked with the shares)

Examples
--------

See `example.log` for details,
or regenerate it with `sudo ./example.sh 2>&1 | tee example.log`.

    # create keys for a 3-of-5 scheme
    horcrux setup 3 5

    # encrypt a message with the encrypt key, and sign it with the sign key
    horcrux encrypt encrypt.key sign.key message.txt message.txt.gpg

    # find files in current directory, then verify + decrypt if possible
    # (this can be run by dragging the working dir to decrypt.desktop)
    horcrux -v autodecrypt

    # verify a message signature
    horcrux verify verify.key message.txt.gpg message.txt.gpg.sig

    # decrypt a 3-of-5 message with 3 key shares
    horcrux decrypt decrypt.key verify.key message.txt.gpg message.txt.gpg.sig message.txt share-0{1,4,5}.key

    # hide a key share in an image, then extract it again
    # (omit the passphrase to be prompted instead)
    horcrux hide   share-01.key example.jpeg share-01.jpeg greatpassphrase
    horcrux unhide share-01.jpeg share-01-unhidden.key greatpassphrase

    # decrypt a 3-of-5 message with 3 key shares, extracting one from an image first
    horcrux decrypt decrypt.key verify.key message.txt.gpg message.txt.gpg.sig message.txt share-01.jpeg share-0{2,4}.key

TODO
----

* should stego files be hidden with a key share as the password by default?
* Use rng-tools?
* Put all tmpfiles in RAM (/tmp? /run? /run/user/1000?)
* Add a second layer of encryption with openssl?

[1]: https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing
[2]: https://tails.boum.org/
