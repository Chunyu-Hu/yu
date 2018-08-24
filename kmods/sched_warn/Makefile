obj-m := warn.o
warn-objs:= warn_mod.o

KDIR := /lib/modules/3.10.0-514.el7.x86_64/build/
PWD := $(shell pwd)

default:
	make -C $(KDIR) M=$(PWD) modules

clean:
	rm -rf *.o .* .cmd *.ko *.mod.c .tmp_versions
