{ config, pkgs, ... }:

{
  # 禁用 systemd-boot
  boot.loader.systemd-boot.enable = false;

  # 作用：尝试向主板 NVRAM 写入 "NixOS" 启动项
  boot.loader.efi.canTouchEfiVariables = true;
  
  # 指定 EFI 挂载点 (必须与 Disko 配置一致)
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # GRUB 配置
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  
  boot.supportedFilesystems = [ "btrfs" ];
}