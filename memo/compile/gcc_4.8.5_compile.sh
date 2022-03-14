 
 cd gcc-4.8.5/
 cd ..
 mkdir 4.8.5-gcc-objs
 cd 4.8.5-gcc-objs/
 cp gcc_4.9.3_env.sh /root/

 export CXX="g++ -std=gnu++98"
 export CC="gcc -std=gnu99"

 make distclean

  ../gcc-4.8.5/configure --enable-bootstrap --enable-languages=c,c++,objc,obj-c++,fortran,go --prefix=/opt/gcc-4.85 --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array --enable-offload-targets=nvptx-none --without-cuda-driver --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-none-linux --with-build-config=bootstrap-lto --enable-link-serialization=1 --with-gmp=/opt/gmp-4.3.2 --with-cloog=/opt/cloog-0.18.1 --with-mpfr=/opt/mpfr-2.4.2 --with-cloop

 make -j12 V=1
 export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/gcc-4.9.3/lib:/opt/gmp-4.3.2/lib:/opt/mpfr-2.4.2/lib:/opt/mpc-0.8.1/lib:/opt/cloog-0.18.1/lib:/opt/openssl-1.0.2/lib

 cp../4.9.3-gcc-objs/x86_64-none-linux/libgcc/md-unwind-support.h  ./x86_64-none-linux/libgcc/md-unwind-support.h
 cp ../4.9.3-gcc-objs/x86_64-none-linux/libgcc/md-unwind-support.h  ./x86_64-none-linux/libgcc/md-unwind-support.h
 
 make -j1 V=1

 cd ../gcc-4.8.5/libsanitizer/asan/
 cd /home/chuhu/Downloads/4.8.5-gcc-objs/
 vim ../gcc-4.8.5/libsanitizer/asan/asan_linux.cc
 cd ../gcc-4.8.5/libsanitizer/asan/
 vim asan_linux.cc 
 cd ../tsan/
 vim tsan_platform_linux.cc 
 cd -
 cd /home/chuhu/Downloads/4.8.5-gcc-objs/
 make -j12 V=1
