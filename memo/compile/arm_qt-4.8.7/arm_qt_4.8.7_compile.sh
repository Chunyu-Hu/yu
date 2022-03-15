export LD_LIBRARY_PATH=/opt/gcc-4.8.5/lib:/opt/gcc-4.8.6/lib64:/opt/arm/gcc-4.8.3/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/arm/openssl-1.0.2/lib:/usr/local/tslib/lib
export PATH=/opt/arm/gcc-4.8.3/bin/:/opt/gcc-4.8.5/bin/:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/home/chuhu/.local/bin:/home/chuhu/bin:/opt/openssl-1.0.2/:/usr/local/tslib/bin
cp  mkspecs/qws/linux-x86_64-g++/qmake.conf  ../

tar -zxf qt-everywhere-opensource-src-4.8.7.tar.gz 
cd qt-everywhere-opensource-src-4.8.7
cd mkspecs/qws/
mkdir linux-armv7-g++
cd linux-armv7-g++/
cp ../../../../qmake.conf ./
cp ../linux-x86_64-g++/qplatformdefs.h ./
./configure -prefix /opt/arm/qt-4.8.7 -opensource -release -shared -embedded arm -xplatform qws/linux-armv7-g++ -qt-sql-sqlite -no-xmlpatterns -no-mmx -no-3dnow -no-sse -no-sse2 -no-svg -no-webkit -qt-zlib -no-gif -qt-libtiff -qt-libpng -qt-libmng -qt-libjpeg -make libs -nomake tools -nomake examples -nomake docs -nomake demos -no-nis -no-cups -no-iconv -no-dbus -no-glib -qt-mouse-tslib -qt-freetype -qt-mouse-qvfb -qt-gfx-linuxfb -no-gfx-multiscreen -no-gfx-transformed -no-gfx-vnc -qt-gfx-qvfb -qt-kbd-qvfb -no-openvg -I/usr/local/tslib/include -L/usr/local/tslib/lib -no-opengl 
gmake -j12 V=1
arm-none-linux-gnueabi-readelf -d ./libQtCore.so.4.8.7 
cd /opt/arm/qt-4.8.7/
ldd ./lib/libQtTest.so
ldd libQtCore.so.4.8.7
cd qt-5.6.3_gcc4_8_3_c++11/
arm-none-linux-gnueabi-readelf -d libQt5Core.so.5.6.3 
cd /home/chuhu/Downloads/qt-everywhere-opensource-src-4.8.7

#history > arm_qt_4.8.7_compile.sh

