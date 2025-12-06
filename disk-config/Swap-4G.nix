{ lib, config, disko, ... }:
{
  imports = [
    disko.nixosModules.disko
    ./boot.nix
  ];

  disko.devices.disk.main = {
    # 这里指定生成的 raw 文件初始大小。
    # 建议设置为 4G 或 5G (或者 3G，只要能装下你的 Nix Store 即可)。
    # 这样生成的 .raw 文件很小，上传到 VPS 后，启动时会自动扩容到 VPS 实际硬盘大小。
    imageSize = "7G";

    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        # 为了在 BIOS+GPT 上启动
        boot = {
          priority = 0;
          size = "1M";
          type = "EF02"; 
        };
        # 1. ESP 分区
        ESP = {
          priority = 1;
          size = "64M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot/efi";
            mountOptions = [ "defaults" ];
          };
        };

        # 2. Swap 分区
        swap = {
          priority = 2;
          size = "4G";
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };

        # 3. Root 分区 (直接使用 Btrfs，移除 LUKS 加密层)
        root = {
          priority = 3;
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = [ "compress-force=zstd:3" "noatime" "space_cache=v2" ];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = [ "compress-force=zstd:3" "noatime" "space_cache=v2" ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress-force=zstd:3" "noatime" "space_cache=v2" ];
              };
              "@log" = {
                mountpoint = "/var/log";
                mountOptions = [ "compress-force=zstd:3" "noatime" "space_cache=v2" ];
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}