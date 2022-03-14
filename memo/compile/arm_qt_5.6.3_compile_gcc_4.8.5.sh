mkdir /opt/arm/qt-5.6.3/docs_for_assistant 
cp `find ./ -name *.qch` /opt/Qt-5.3.2/docs_for_assistant 
cp `find ./ -name *.qch` /opt/arm/qt-5.6.3/docs_for_assistant 
ls /opt/arm/qt-5.6.3/docs_for_assistant/
ls /opt/arm/qt-5.6.3/
ls /opt/arm/qt-5.6.3/bin/
ls /opt/arm/qt-5.6.3/lib/
tar -Jxvf qt-everywhere-opensource-src-5.6.3.tar.xz 
cd qt-everywhere-opensource-src-5.6.3
source env.sh 
./configure -qt-xcb -prefix /optc/x86_64/qt-5.6.3-no-c++11 --no-c++11 
cd /home/chuhu/Downloads/qt-everywhere-opensource-src-5.6.3/
./configure -qt-xcb -prefix /optc/x86_64/qt-5.6.3-no-c++11 --no-c++11 
ls
make -j12 V=1
vim qtbase/mkspecs/linux-g++/qmake.conf 
vim env.sh 
./configure -qt-xcb -prefix /optc/x86_64/qt-5.6.3-no-c++11 --no-c++11 
env | grep CXX
export LD_LIBRARY_PATH=/opt/gcc-4.4.3/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib
