qemu-system-aarch64 \
  -machine virt,accel=kvm \
  -cpu max \
  -m 2G \
  -drive if=pflash,format=qcow2,file=/usr/share/edk2/aarch64/QEMU_EFI-silent-pflash.qcow2,readonly=on \
  -drive if=pflash,format=qcow2,file=/var/lib/libvirt/qemu/nvram/2_memory_hotplug_kvm_kernel_VARS.qcow2 \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::56788-:22 \
  -device virtio-blk-device,drive=drive0 \
  -drive file=/home/virtimages/VirtualMachines/2_memory_hotplug_kvm_kernel.img,if=none,id=drive0,cache=none,aio=native,format=raw \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-pci,rng=rng0 \
  -device virtio-keyboard-pci \
  -monitor telnet::9000,server,nowait \
  -serial stdio \
  -display none \
  -nographic

