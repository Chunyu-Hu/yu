obj-m := percpu.o

KDIR := /lib/modules/`uname -r`/build/
#KDIR := /lib/modules/3.10.0-514.el7.x86_64/build/
PWD := $(shell pwd)

default:
	make -C $(KDIR) V=1 M=$(PWD)

clean:
	rm -rf *.o .* .cmd *.ko *.mod.c .tmp_versions
