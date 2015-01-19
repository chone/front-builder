#!/bin/bash

bin=`dirname $0`

$bin/../closure-library/closure/bin/build/depswriter.py \
  --root_with_prefix="$bin/../closure-templates ../../../closure-templates" \
  --root_with_prefix="$bin/../mem ../../../mem" \
  > $bin/../deps.js


