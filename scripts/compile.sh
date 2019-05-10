#!/usr/bin/env bash
set -xeuo pipefail

errmsg="STORE_PASSWORD and KEY_PASSWORD must be set!"

KEYFILE=MyApp-release-key.jks
KEY_ALIAS=myapp

# generate a key with keytool - it will ask for passwords
if ! [ -e $KEYFILE ] ; then
   keytool -genkeypair -v -keystore $KEYFILE -keyalg RSA -keysize 2048 -validity 10000 -alias $KEYALIAS
fi

./gradlew clean
./gradlew assembleRelease \
 -Pandroid.injected.signing.store.file=$KEYFILE \
 -Pandroid.injected.signing.store.password=${STORE_PASSWORD:?$errmsg} \
 -Pandroid.injected.signing.key.alias=$KEY_ALIAS \
 -Pandroid.injected.signing.key.password=${KEY_PASSWORD:?$errmsg}
