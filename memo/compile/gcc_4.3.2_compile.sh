[root@localhost 4.4.3-gcc-objs]# mkdir 4.3.2-gmp-objs
mkdir 4.4.3-gcc-objs
mkdir 2.4.2-mpfr-objs
mkdir 0.8.1-mpc-objs
mkdir 0.12.2-isl-objs
mkdir 0.18.1-cloog-objs
[root@localhost 4.4.3-gcc-objs]# ../cloog-0.18.1/configure --with-isl-prefix=/opt/isl-0.12.2 --with-gmp-prefix=/opt/gmp-4.3.2 --prefix=/opt/cloog-0.18.1
[root@localhost 4.4.3-gcc-objs]#  wget https://ftp.gnu.org/gnu/gcc/gcc-4.4.3/gcc-4.4.3.tar.gz
[root@localhost 4.4.3-gcc-objs]# mkdir 4.4.3-gcc-objs
[root@localhost 4.4.3-gcc-objs]# export CC="gcc -std=gnu89"
[root@localhost 4.4.3-gcc-objs]# ../gcc-4.4.3/configure --enable-bootstrap --enable-languages=c,c++,objc,obj-c++,fortran --prefix=/opt/gcc-4.4.3 --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --with-linker-hash-stylef=gnu --enable-plugin --enable-initfini-array --enable-offload-targets=nvptx-none --without-cuda-driver --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-none-linux --with-build-config=bootstrap-lto --enable-link-serialization=1 --with-gmp=/opt/gmp-4.3.2 --with-cloog=/opt/cloog-0.18.1 --with-mpfr=/opt/mpfr-2.4.2
[root@localhost 4.4.3-gcc-objs]# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib
[root@localhost 4.4.3-gcc-objs]# make -j10 V=1
[root@localhost 4.4.3-gcc-objs]# vim ../gcc-4.4.3/gcc/config/i386/linux-unwind.h +54
[root@localhost 4.4.3-gcc-objs]# vim ../gcc-4.4.3/gcc/config/i386/linux-unwind.h +138
