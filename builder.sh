#!/bin/bash

path=`dirname $0`

namespace=$1
out=${namespace//\.main/}
out=${out//\./\/}
outputPath=$path/../build/$out

mkdir -p `dirname $outputPath.js`

echo ""
echo ">> Compilie"
echo ""

$path/../closure-library/closure/bin/build/closurebuilder.py \
  --root=$path/../closure-library/ \
  --root=$path/../closure-templates/ \
  --namespace="$namespace" \
  --output_mode=compiled \
  --compiler_flags="--compilation_level=ADVANCED_OPTIMIZATIONS" \
  --compiler_flags="--define=goog.DEBUG=false" \
  --compiler_flags="--output_wrapper=(function(){%output%})();" \
  --compiler_flags="--js_output_file=$outputPath.o" \
  --compiler_jar=$path/../closure-compiler/compiler.jar 
  
id=`md5sum $outputPath.o | cut -d ' ' -f 1`
mv $outputPath.o ${outputPath}-$id.js 

echo ""
echo ">> Done"
echo ""
echo "$outputPath-$id.js"


