#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $script_dir

git submodule update --init --recursive

while getopts :bd opt
do
  case $opt in
    b) build="build" ;;
    d) docker="docker" ;;
  esac
done

if [[ $build = "build" ]]; then
  docker build -t bats-tests ./
fi

if [[ $docker = "docker" ]]; then
  echo "Running bats in container"
  docker run -t bats-tests
else
  echo "Running bats locally"
  ./test/libs/bats/bin/bats test/
fi
