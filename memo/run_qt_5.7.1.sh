app=${1:-curvdemo1}
export QT_DEBUG_PLUGINS=1
export QTDIR=/opt/qt-5.7.1.gcc4_8_3
export QT_QWS_FONTDIR=$QTDIR/lib/fonts
export LD_LIBRARY_PATH=/opt/arm/qt-5.7.1.gcc4_8_3/lib:/opt/arm/qwt-6.1.2.gcc_4_8_3/lib:/opt/tslib-1.4/lib:$LD_LIBRARY_PATH 
export QWS_DISPLAY=LinuxFB:mmWidth=800:mmHeight=400
export LD_PRELOAD=./preloadable_libiconv.so
ldd $app
#./$app -qws -font wenquanyi
./$app
