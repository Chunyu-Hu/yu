obj-$(CONFIG_BASE_LIB) := base.o
base-objs := base_lib.o
ccflags-y += -Werror=format-security

$(warning $(ccflags-y))
$(warning $(CFLAGS))

KARCH := $(shell uname -m)
KVR:= 3.10.0-500.el7
KDIR_1 := /root/rpmbuild/BUILD/kernel$(KVR)/linux-3.10.0-500.el7.x86_64/
KDIR_2 := /home/chuhu/Git/linux
KDIR_3 := /usr/lib/modules/$(shell uname -r)/build
KDIR_4 := /usr/lib/modules/$(KVR).$(KARCH)/build

KDIR= $(KDIR_4)
PWD := $(shell pwd)

default:
	make -C $(KDIR) M=$(PWD) modules V=0
clean:
	make -C $(KDIR) M=$(PWD) clean
