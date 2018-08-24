 virt-install --memory 2048  --name rhel-7.5  --memballoon virtio  --cdrom RHEL-7.5-20180322.0-Server-x86_64-dvd1.iso --disk /home/libvirt/rhel-7.5.qcow2,size=40 --boot uefi 
yum -y install OVMF
