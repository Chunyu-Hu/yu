QT_VERSION=5.7.1.gcc4_8_3
GCC_VERSION=4.8.5
QWT_VERSION=6.1.2.gcc_4_8_3

CROSS_COMPILE_LINARO_GCC=/opt/arm/gcc-$GCC_VERSION-linaro
CROSS_COMPILE_SOURCERY_GCC=/work/yctools/arm-2009q3
CROSS_COMPILE_SOURCERY_GCC_LATEST=/opt/arm/gcc-4.8.3

#CROSS_COMPILE_GCC_VERSION=4.4.1
CROSS_COMPILE_GCC_PATH=$CROSS_COMPILE_SOURCERY_GCC_LATEST
CROSS_COMPILE_QT_VERSION=5.7.1.gcc4_8_3
CROSS_COMPILE_TSLIB_PATH=/opt/arm/tslib-1.4.gcc_4_8_3

ARM_LIBRARY=$CROSS_COMPILE_GCC_PATH/lib:/opt/arm/qt-$CROSS_COMPILE_QT_VERSION/lib:/opt/arm/openssl-1.0.2/lib:$CROSS_COMPILE_TSLIB_PATH/lib:/opt/arm/qwt-$QWT_VERSION/lib
ARM_PATH=$CROSS_COMPILE_GCC_PATH/bin:/opt/arm/qt-$CROSS_COMPILE_QT_VERSION/bin:/opt/arm/openssl-1.0.2/bin:/opt/arm/qwt-$QWT_VERSION/bin

BASE_FILE=arm
export QT_QPA_PLATFOMR='offscreen'

if echo $BASE_FILE | grep -iq x86; then

	export LD_LIBRARY_PATH=/opt/gcc-$GCC_VERSION/lib:/opt/x86_64/gcc-$GCC_VERSION/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/x86_64/qt-$QT_VERSION/lib:/optc/x86_64/qt-$QT_VERSION/lib
	export PATH=/opt/gcc-$GCC_VERSION/bin/:/opt/x86_64/gcc-$GCC_VERSION:/optc/x86_64/qt-$QT_VERSION/bin:/opt/x86_64/qt-$QT_VERSION/bin:/opt/x86_64/qt-$QT_VERSION/bin:$PATH

	echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH
	echo PATH=$PATH

elif echo $BASE_FILE | grep -i arm; then

	export LD_LIBRARY_PATH=$ARM_LIBRARY:/opt/gcc-$GCC_VERSION/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib:/opt/arm/qt-$QT_VERSION/lib
	export PATH=$ARM_PATH:/opt/gcc-$GCC_VERSION/bin/:/opt/arm/qt-$QT_VERSION/bin:/opt/arm/qt-$QT_VERSION/bin:$PATH

	echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH
	echo PATH=$PATH

else
	echo "Nothing is exported! Please rename your script to arm_* or x86_*"
fi
