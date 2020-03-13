#!/bin/sh

TMP_DIR=$(mktemp -d commitlint-pre-receive-hook.XXXXXXXX)

config_file='.commitlintrc.yml'
mkdir "$TMP_DIR/source"

ERRORS="Commitlint Verified"
RETVAL=0

while read oldrev newrev refname
do
  git show ${refname}:$config_file 1>"$TMP_DIR/source/$config_file" 2>/dev/null
  OUTPUT=$(commitlint -g "$TMP_DIR/source/$config_file" -f $oldrev -t $newrev)
  if [ "$?" -ne "0" ]; then
      ERRORS="${ERRORS}${OUTPUT}"
      RETVAL=1
  fi
done

rm -rf $TMP_DIR

echo "$ERRORS"
exit $RETVAL