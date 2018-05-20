#!/bin/sh


if [ "$1" == "" ]; then
  echo "Use \$1 to select test bench 1~3"
  echo "Example: ./run_nc_post.sh 1 => run test 1"
else
  cd sim
  ncverilog -f post_sim.f +define+tb$1
fi
