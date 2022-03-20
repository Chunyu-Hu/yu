
mkdir qt-everywhere-opensource-src-5.6.3.gcc-4.8.3.arm
tar -Jxf qt-everywhere-opensource-src-5.6.3.tar.xz  -C qt-everywhere-opensource-src-5.6.3.gcc-4.8.3.arm/
cd qt-everywhere-opensource-src-5.6.3.gcc-4.8.3.arm/
cp /root/gcc_4.8.5_env.sh ./
vim gcc_4.8.5_env.sh 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/gcc-4.4.3/lib:/opt/x86_64/QT-4.7.3/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/work/yctools/arm-2009q3/lib

touch arm_linux_gcc_4.8.3_env.sh
chmod +x arm_linux_gcc_4.8.3_env.sh 

./config no-asm shared --prefix=/opt/arm/openssl-1.0.2/ --cross-compile-prefix=arm-none-linux-gnueabi- 
make -j4 V=1
make install -j12
/opt/arm/openssl-1.0.2/bin/openssl version

cd /home/chuhu/Downloads/qt-everywhere-opensource-src-5.6.3.gcc-4.8.3.arm/qt-everywhere-opensource-src-5.6.3/
export LD_LIBRARY_PATH=/opt/arm/gcc-4.8.3/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/arm/openssl-1.0.2/lib
# Note add the tslib path to configure:
# -L/opt/arm/tslib-1.4.gcc_4_8_3/lib
#./configure -release -opensource -xplatform linux-arm-gnueabi-g++ -prefix /opt/arm/qt-5.6.3_gcc4_8_3 -no-opengl -no-dbus -qreal float -L/opt/arm/tslib-1.4.gcc_4_8_3/lib
./configure -release -opensource -xplatform linux-arm-gnueabi-g++ -prefix /opt/arm/qt-5.6.3_gcc4_8_3 -no-opengl -no-dbus -qreal float -L/opt/arm/tslib-1.0.2/lib
make -j12 V=1
make install -j12 V=1
ls
history  > arm_qt_5.6.5_compile.sh
