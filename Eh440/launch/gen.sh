#!/bin/sh

resize() {
  W=$1
  H=$2
  I=$3
  O=$4
  sips --resampleWidth $W $I --out test.png
  ./chopper $W $H test.png $O
  rm test.png
}

rm Default*

# IOS8,9
resize 1242 2208 launch.png Default@retinahd55.png
resize 750 1334 launch.png Default@retinahd47.png

# IOS7-9
resize 640 960 launch.png Default@2x.png
resize 640 1136 launch.png Default@retina4.png

# IOS5,6
resize 320 480 launch.png Default.png

