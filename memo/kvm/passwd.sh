rpm -q libguestfs-tools || yum -y install libguestfs-tools
LIBGUESTFS_BACKEND=direct virt-customize -a xxxxx.img --root-password password:foobar --selinux-relabel --timezone Europe/Helsinki --uninstall cloud-init

