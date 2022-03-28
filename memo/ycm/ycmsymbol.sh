find /opt/x86_64/qt-5.7.1.gcc4_8_5/include/  -mindepth 2 -maxdepth 3 -type d -a -printf "'-I','%h',\n"
