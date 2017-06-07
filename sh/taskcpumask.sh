for p in $(pgrep kworker/u); do find /proc/$p -maxdepth 2 -name status  -exec grep -i cpus_allowed_list {} \; -a -exec cat /proc/$p/comm \; -printf "%h\n\n"; done
