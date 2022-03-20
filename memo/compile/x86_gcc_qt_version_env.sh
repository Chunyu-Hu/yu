QT_VERSION=5.7.1.gcc4_8_5
GCC_VERSION=4.8.5
CROSS_COMPILE_GCC_VERSION=4.4.1
CROSS_COMPILE_GCC_PATH=/work/yctools/arm-2009q3
CROSS_COMPILE_QT_VERSION=4.8.7
CROSS_COMPILE_TSLIB_PATH=/usr/local/tslib/lib/

ARM_LIBRARY=$CROSS_COMPILE_GCC_PATH/lib:/opt/arm/qt-$CROSS_COMPILE_QT_VERSION/lib:/opt/arm/openssl-1.0.2/lib:$CROSS_COMPILE_TSLIB_PATH/lib
ARM_PATH=$CROSS_COMPILE_GCC_PATH/bin:/opt/arm/qt-$CROSS_COMPILE_QT_VERSION/bin

BASE_FILE=x86

export QT_QPA_PLATFOMR='offscreen'

if echo $BASE_FILE | grep -iq x86; then

	export LD_LIBRARY_PATH=/opt/gcc-$GCC_VERSION/lib:/opt/x86_64/gcc-$GCC_VERSION/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/x86_64/qt-$QT_VERSION/lib:/optc/x86_64/qt-$QT_VERSION/lib
	export PATH=/opt/gcc-$GCC_VERSION/bin/:/opt/x86_64/gcc-$GCC_VERSION:/optc/x86_64/qt-$QT_VERSION/bin:/opt/x86_64/qt-$QT_VERSION/bin:/opt/x86_64/qt-$QT_VERSION/bin:$PATH

	echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH
	echo PATH=$PATH

elif echo $0 | grep -i arm; then

	export LD_LIBRARY_PATH=$ARM_LIBRARY:/opt/gcc-$GCC_VERSION/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/x86_64/qt-$QT_VERSION/lib:/optc/x86_64/qt-$QT_VERSION/lib
	export PATH=$ARM_PATH:/opt/gcc-$GCC_VERSION/bin/:/opt/x86_64/qt-$QT_VERSION/bin:/opt/x86_64/qt-$QT_VERSION/bin:$PATH

	echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH
	echo PATH=$PATH

else
	echo "Nothing is exported! Please rename your script to arm_* or x86_*"
fi
