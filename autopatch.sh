#!/usr/bin/env bash

## Copyright (c) Czwl Cd. <https://github.com/czwl>
## Licensed under the MIT License

## autopatch.sh
## A patch -p1 which can integrate patch in the script itself.
## Requires bash verison > 4

## Currently has no multi patch and sanity check support

PATCH_BASE="frameworks/base/data/keyboards"

if [[ ! -d "$PATCH_BASE" ]]; then
	echo "Please call this script from Root directory for now"
	exit -1
fi

do_patch() {
	temp_patch="$(mktemp "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX.patch")"

	cat >$temp_patch <<EOF
--- a/Generic.kl        2020-04-30 11:16:06.382855559 +0000
+++ b/Generic.kl        2020-04-30 11:21:35.673278030 +0000
@@ -191,7 +191,7 @@
 key 169   CALL
 # key 170 "KEY_ISO"
 key 171   MUSIC
-key 172   HOME
+key 172   WAKE
 key 173   REFRESH
 # key 174 "KEY_EXIT"
 # key 175 "KEY_MOVE"
EOF

	cd "$PATCH_BASE"
	if patch -p1 --dry-run -R <$temp_patch >/dev/null; then
		echo "Patch already applied"
		exit 0
	else
		patch -p1 <$temp_patch
	fi

}

do_patch
