#! /usr/env bash

if [ "$1" != win -a "$1" != nowin ]; then
  echo "please use either 'win' or 'nowin' as argument.";

else {
  dir="$(dirname "$(readlink -f "$0")")"
  echo "$dir"
  cd "$dir"
  cd ..

  find . -not \( \
    -name "*~" \
    -o -path "*/.*/*" \
    -o -name ".*" \
    -o -path "*/build/*" \
    -o -path "*/doc/*" \
  \) | zip -u build/output/xelda.love -@

  echo $1
  if [ "$1" == win ]; then {
    cd build

    cat input/love32.exe output/xelda.love > output/win32/Game.exe
    zip -u output/win32.zip input/win32/*

    cat input/love64.exe output/xelda.love > output/win64/Game.exe
    zip -u output/win64.zip input/win64/*
  }; fi
}; fi

