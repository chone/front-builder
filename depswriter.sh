#!/bin/bash

bin=`dirname $0`

$bin/../closure-library/closure/bin/build/depswriter.py \
  --root_with_prefix="$bin/../ ../../../" \
  > $bin/../deps.js


