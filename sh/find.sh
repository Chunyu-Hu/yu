find /proc/  -maxdepth 3 -name maps -exec grep 'stack\]' {} \; -printf "%h/%f " |awk '{split($2, a, /-/); if(a[1] > a[2]) print $0}'
