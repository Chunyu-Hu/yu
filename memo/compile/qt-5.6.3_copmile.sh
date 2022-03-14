tar -Jxf qt-everywhere-opensource-src-5.6.3.tar.xz 
cd qt-everywhere-opensource-src-5.6.3
cp ../qmake.conf ./qtbase/mkspecs/linux-g++/qmake.conf 
cd ../5.6.3-qt-objs/
../configure -qt-xcb -prefix /optc/x86_64/qt-5.6.3 
vim  ./qtbase/mkspecs/linux-g++/qmake.conf 
../configure -qt-xcb -prefix /optc/x86_64/qt-5.6.3 
../qt-everywhere-opensource-src-5.6.3/configure -qt-xcb -prefix /optc/x86_64/qt-5.6.3 
vim  ./qtbase/mkspecs/linux-g++/qmake.conf 
cd -
../qt-everywhere-opensource-src-5.6.3/configure -qt-xcb -prefix /opt/x86_64/qt-5.6.3.c++11 
make install -j12
cd /optc/x86_64/qt-5.6.3.c++11/
ls /opt/arm/gcc-4.8.3/bin/gcc -v
ls /opt/arm/gcc-4.8.3/bin/arm-none-linux-gnueabi-gcc -v
/opt/arm/gcc-4.8.3/bin/arm-none-linux-gnueabi-gcc -v
cd /home/chuhu/Downloads/qt-everywhere-opensource-src-5.6.3/
history > qt-5.6.3_copmile.sh

#qtbase/mkspecs/linux-g++/qmake.conf
MAKEFILE_GENERATOR      = UNIX
CONFIG                 += incremental
QMAKE_INCREMENTAL_STYLE = sublib

QMAKE_CFLAGS_RELEASE   += -O2 -I /opt/openssl-1.0.2/include
QMAKE_CXXFLAGS_RELEASE += -O2 -std=gnu++11 -I /opt/openssl-1.0.2/include
QMAKE_CC                = gcc -std=gnu99
#QMAKE_CFLAGS_RELEASE   += -O2 -I/opt/x86_64/openssl-1.1.1l/include/openssl -I /opt/openssl-1.0.2/include/openssl
#QMAKE_CXXFLAGS_RELEASE += -O2 -I/opt/x86_64/openssl-1.1.1l/include/openssl -I /opt/openssl-1.0.2/include/openssl -std=gnu++98
#QMAKE_CXX               = arm-none-linux-gnueabi-g++

include(../common/linux.conf)
include(../common/gcc-base-unix.conf)
include(../common/g++-unix.conf)
load(qt_config)

