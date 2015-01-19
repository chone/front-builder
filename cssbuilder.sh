#!/bin/bash

opts() {
  while getopts "s" optname; do
    case "$optname" in
      "s")
        echo 'simple'
        ;;
      ":")
	echo 'closure'
	;;
    esac
  done
  return $OPTIND
}

args() {
  for p in "$@"; do
    echo $p
  done
}

opt=$(opts "$@")
argstart=$?
arg=$(args "${@:$argstart}")

bin=$(dirname $0)
mode=$opt
namespace=`echo $arg | awk '{print $1}'`
cdn=`echo $arg | awk '{print $2}' | sed -E "s/\/$//" \
  | sed -E "s/(.*:\/\/)?/http:\/\//"`

if [[ $cdn == 'http://' ]]; then
  cdn='/images'
fi

if [ -z "$namespace" ]; then
  echo 'Usage: ./cssbuilder.sh NAMESPACE'
  echo ''
  echo 'Example: ./cssbuilder.sh ex.css.home.main'
  exit 0
fi

path=${namespace//\.main/}
path=${path//\./\/}
compiler=$bin/../closure-stylesheets/closure-stylesheets.jar
css=$bin/../src/css
main=$bin/../$path/main.css
out=$bin/../build/${path}

mkdir -p $(dirname ${out}.css)

if [ -a $main ]; then

  if [[ $cdn == '/images' ]]; then
    inlineCdn=`cat $main | \
      grep '/*cdn=[^*]**/' | \
      awk '{print $2}' | \
      cut -d "=" -f 2` 
    if [[ $inlineCdn != '' ]]; then
      cdn=$inlineCdn
    fi
  fi

  if [[ $mode == 'simple' ]]; then
    # 
    tmp=${out}.o
        node $bin/cssbuilder.js $namespace $cdn >> $tmp
  else
    # compile with closure stylesheets
    cat $main \
      | sed -E "s/.*url\([\.\/]*(css)?([^\(\)'\"]*)\);?/\1/" \
      | xargs -i echo $css{} \
      | xargs java -jar $compiler --allow-unrecognized-functions\
      | sed "s#[\.\/]*images#${cdn}#" \
      | xargs echo >> ${out}.o
  fi

  if [ -a ${out}.o ]; then
    id=$(md5sum ${out}.o | cut -d ' ' -f 1)
    mv ${out}.o ${out}-${id}.css
    echo ""
    echo ">>> Done."
    echo ""
    echo "${out}-${id}.css"
  fi

else
  echo "No such file: $main"
fi
