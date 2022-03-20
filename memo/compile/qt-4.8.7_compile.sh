./configure -prefix /optc/x86_64/qt-4.8.7 
export LD_LIBRARY_PATH=/opt/gcc-4.8.5/lib:/opt/arm/gcc-4.8.3/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/arm/openssl-1.0.2/lib
env  | grep LD
export LD_LIBRARY_PATH=/opt/gcc-4.8.5/lib:/opt/gcc-4.8.6/lib64:/opt/arm/gcc-4.8.3/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/arm/openssl-1.0.2/lib
vim mkspecs/linux-g++/qmake.conf 
vim mkspecs/common/g++-base.conf 
make confclean -j8
./configure -prefix /optc/x86_64/qt-4.8.7 
vim mkspecs/common/g++-base.conf 
vim mkspecs/linux-g++/qmake.conf 
make -j12 V=1
make install -j12 V=1
/opt/x86_64/qt-5.6.3.c++11/bin/qmake -v
vim /root/memo/compile/arm_qt_5.6.3_compile.sh 
#history > qt-4.8.7_compile.sh

#mkspecs/linux-g++/qmake.conf
QMAKE_CFLAGS_RELEASE   += -O2 -I /opt/openssl-1.0.2/include
QMAKE_CXXFLAGS_RELEASE += -O2 -std=gnu++98 -I /opt/openssl-1.0.2/include
QMAKE_CC                = gcc -std=gnu99
QMAKE_CXX                = gcc -std=gnu++98

#mkspecs/common/g++-base.conf
QMAKE_CXX = g++ -std=gnu++98
