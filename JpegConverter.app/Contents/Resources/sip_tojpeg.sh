#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

do_file() {
  local fname="${*%.*}.jpg"
  if [ ! -e "$fname" ]; then
    sips -s format jpeg "$*" --out "$fname"
    echo "created : $fname"
  fi
}

main() {
  for f in "$@" ; do
    if [ -d "$f" ]; then
      (
        IFS=$'\n';
        for fpath in $(find "$f" -maxdepth 1 -type f ! -name '.*') ; do
          if [ -f "$fpath" ]; then
            do_file "$fpath"
          fi
        done
      )
    elif [ -f "$f" ]; then
      do_file "$f"
    fi
  done
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "h:" opt; do
  case $opt in
    h)
      usage ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

