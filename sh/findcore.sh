#!/bin/sh

tuna -S1 -i
taskset -c 1,5,9,13,17,21,25,29,33,37,41,45 cyclictest -- -a 1,5,9,13,17,21,25,29,33,37,41,45 -t 12 -m -d 30 -D 350 --quiet   &> /dev/null &
echo 1 > /sys/devices/virtual/workqueue/writeback/cpumask 
echo 0 > /sys/devices/virtual/workqueue/writeback/numa
perf stat -e workqueue:workqueue_execute_start -C 1,5,9,13,17,21,25,29,33,37,41,45 -- sleep 200

