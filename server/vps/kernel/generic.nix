{ pkgs, ... }:

{
  # 强制加载这组“全家桶”驱动，覆盖自动检测的结果
  boot.initrd.availableKernelModules = [
    # --- 存储控制器 (物理机主力) ---
    "nvme"           # NVMe M.2 SSD (现代笔记本/台式机/服务器必选)
    "ahci"           # SATA 硬盘 (机械硬盘/老式SSD)
    "sd_mod"         # SCSI/SATA/USB 存储核心模块 (所有块设备的基础)
    "sr_mod"         # 光驱/ISO镜像 (虚拟机挂载ISO安装盘需要)

    # --- USB 支持 (键盘/鼠标/外置盘启动) ---
    "xhci_pci"       # USB 3.0/3.1 (绝大多数现代机器的核心USB驱动)
    "ehci_pci"       # USB 2.0 (老机器)
    "uhci_hcd"       # USB 1.1 (非常老的主板，以及部分虚拟机的模拟键鼠)
    "usb_storage"    # USB 闪存盘驱动 (从优盘启动系统需要)
    "usbhid"         # USB 键盘/鼠标 (启动阶段输入 LUKS 密码必选)

    # --- 虚拟化支持 (涵盖 KVM, VMware, Xen) ---
    "virtio_pci"     # QEMU/KVM PCI 总线 (虚拟硬件的基础)
    "virtio_scsi"    # QEMU/KVM SCSI 存储 (高性能虚拟磁盘)
    "virtio_blk"     # QEMU/KVM 块设备 (旧式或简单配置)
    "vmw_pvscsi"     # VMware ESXi/Workstation 准虚拟化 SCSI
    "xen_blkfront"   # Xen 虚拟化磁盘 (AWS EC2 旧实例/Citrix)

    # --- 遗留兼容性 ---
    "ata_piix"       # Intel PIIX IDE (QEMU 默认模拟的 IDE 控制器)
  ];

  # 允许安装非自由固件（Wifi、GPU 驱动通常需要这个）
  hardware.enableRedistributableFirmware = true;

  # 同时启用 Intel 和 AMD 的微码更新
  # NixOS 会根据当前 CPU 自动决定应用哪一个，或者都安装但只加载需要的
  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;

  # 启用通用的所有固件包（涵盖大多数硬件）
  hardware.firmware = [ pkgs.linux-firmware ];
  
}