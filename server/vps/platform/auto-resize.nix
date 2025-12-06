{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    # 引入 QEMU Guest 支持 (包含 virtio 驱动，对 VPS 很重要)
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  # 1. 启动时自动修复 GPT 分区表并扩容最后一个分区
  boot.growPartition = true;

  # 2. 针对 Btrfs 根分区的自动扩容配置
  fileSystems."/" = {
    autoResize = true;
    # 确保挂载选项中有 compress 等原有配置，这里不需要重复写 mountOptions，
    # 因为 Disko 中已经定义了，这里主要是追加 autoResize 属性。
  };

  # 3. 确保必要的工具在系统路径中 (cloud-utils 包含 growpart)
  environment.systemPackages = [ pkgs.cloud-utils ];

  # 4. 可选：如果是无头服务器，强制串行控制台 (你原来的 generic.nix 已经有了，这里可以忽略)
  # boot.kernelParams = [ "console=ttyS0" ];
}