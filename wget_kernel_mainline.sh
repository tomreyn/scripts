#!/bin/bash
set -e

B="http://kernel.ubuntu.com/~kernel-ppa/mainline"
RET=0
FILE_LIST="mainline-kernel.list"
DOWNLOAD_ONLY=false
SHASUM=sha1sum
CHECKSUM_BLOCK="Checksums-Sha1:"
help()
{
  cat <<EOT
Copyright 2014-2017 Tj <ubuntu@iam.tj>
Licensed on the terms of the GNU General Public License version 3
 
This script automates the fetching of the Ubuntu mainline kernel build packages
If run with no options it will identify, download, and install the latest build
(which could be a Release Candidate (RC) from
  http://kernel.ubuntu.com/~kernel-ppa/mainline
If passed a version number as its only argument that version will be fetched and 
installed. e.g:
 wget_kernel_mainline.sh v4.13
Options:
  -d download only
  -h this help
  -l list available versions
  -sha256 verify using SHA256 sums rather than SHA1
EOT
}

wget_list()
{
  wget -O - "$B/" 2>/dev/null | grep '\[DIR\]' | sed -n 's,.*a href="\(v.*\)/">v.*,\1,p' > "$FILE_LIST"
}

V=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d)
      DOWNLOAD_ONLY=true
      shift
      ;;
    -sha256)
      echo "SHA256 checksums enabled"
      CHECKSUM_BLOCK="Checksums-Sha256:"
      SHASUM=sha256sum
      shift
      ;;
    -l)
      wget_list
      cat "$FILE_LIST"
      exit 0
      ;;
    -h)
      help
      exit 0
      ;;
    *)
      V="$V $1"
      shift
      ;;
  esac
done

wget_list

if [ -z "$V" ]; then
  # identify latest version
  V="$(tail -1 "$FILE_LIST")"
else
  if ! wget -O - "$B/$V" 2>/dev/null >&2; then
    echo "error: Cannot find version $V in the Ubuntu mainline kernel archive" >&2
    exit 1
  fi
fi

mkdir -p "$V" && pushd "$V" >/dev/null || exit 1
# fetch each Debian package in the version's directory
ARCH=$(dpkg --print-architecture)
UNAME=$(uname -r)
FLAVOUR=${UNAME##*-}
if [ ! "x$FLAVOUR" = "xgeneric" -a ! "x$FLAVOUR" = "xlowlatency" ]; then
  FLAVOUR=""
fi

echo "Fetching version: $V architecture: $ARCH flavour: $FLAVOUR"
for U in $(wget -O - "$B/$V" 2>/dev/null | sed -n "s,.*a href=\"\(linux-.*\(-${FLAVOUR}\|\)_.*\(${ARCH}\|all\)\.deb\)\">.*,\1,p"); do
  if [ ! -f "$U" ]; then
    echo "Fetching $B/$V/$U"
    ${DEBUG} wget "$B/$V/$U";
  else
    echo "info: skipping download; already have $V/$U"
  fi
done

echo
echo "Fetching the CHECKSUMS and signature"
wget -nc "$B/$V/CHECKSUMS"
wget -nc "$B/$V/CHECKSUMS.gpg"
echo
echo "Verifying the CHECKSUM signature"
if ! gpg2 --no-default-keyring --keyring /etc/apt/trusted.gpg --verify CHECKSUMS.gpg CHECKSUMS; then
  echo "ERROR: failed to verify the CHECKSUM signature"
  echo "  do you need to add the package signing key to the system keyring?"
  echo "    sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com <KEYID>"
  RET=1
fi

TMP_CHECKSUMS="/tmp/CHECKSUMS_${RANDOM}"
echo
echo "Verifying CHECKSUMS of downloaded files using $SHASUM"

CHECKSUM_READ=false
while read CHECKSUM FILE; do
  if [ "x$FILE" = "x$CHECKSUM_BLOCK" ]; then
    CHECKSUM_READ=true
  elif [ "x$FILE" = "x" ]; then
	CHECKSUM_READ=false
    continue
  fi
  if $CHECKSUM_READ; then
    # only want to verify files that were downloaded
    if [ -f "$FILE" ]; then
      echo "$CHECKSUM  $FILE" >> $TMP_CHECKSUMS
    fi
  fi
done < "CHECKSUMS"

if [ -f "$TMP_CHECKSUMS" ]; then
  echo "Verifying $CHECKSUM_BLOCK"
  if ! $SHASUM -c $TMP_CHECKSUMS; then
    echo "Error: Checksums did not verify"
    rm $TMP_CHECKSUMS
    RET=2
  fi
fi  
popd >/dev/null

if ! $DOWNLOAD_ONLY; then
  if [ $RET -eq 0 ]; then
    ${DEBUG} sudo dpkg -i $V/linux-*${FLAVOUR}*${ARCH}.deb $V/linux-headers-*_all.deb
  else
    echo "Error: exit with code $RET"
  fi
fi

exit $RET
