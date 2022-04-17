IMG=${1:-2_memory_hotplug_kvm.img}

echo "Trying to rescue virtula machine $IMG"
echo "Path: /home/virtimages/VirtualMachines/$IMG"
echo "/usr/libexec/qemu-kvm -m 2048M -net nic -net user,host=10.0.2.10,hostfwd=tcp::56788-:22 -display none -serial stdio -smp sockets=1,cores=1,threads=1  -enable-kvm  -hda /home/virtimages/VirtualMachines/$IMG  -vnc 0.0.0.0:1 -monitor telnet:127.0.0.1:1234,server,nowait -gdb tcp::1235 -machine pc-q35-rhel7.5.0,accel=kvm,usb=off,dump-guest-core=off -cpu IvyBridge"

/usr/libexec/qemu-kvm -m 4096M -net nic -net user,host=10.0.2.10,hostfwd=tcp::56788-:22 -display none -serial stdio -smp sockets=1,cores=1,threads=1  -enable-kvm  -hda /home/virtimages/VirtualMachines/$IMG  -vnc 0.0.0.0:1 -monitor telnet:127.0.0.1:1234,server,nowait -gdb tcp::1235   -machine q35,accel=kvm,usb=off,dump-guest-core=off -cpu IvyBridge
