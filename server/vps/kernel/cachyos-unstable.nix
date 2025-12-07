{ pkgs, inputs, ... }:
{
  imports = [
    # Unstable 版本推荐直接使用 default 模块
    inputs.chaotic.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  services.scx.enable = true;
}
