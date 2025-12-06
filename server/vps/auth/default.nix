{ config, pkgs, ... }:

{
  # --- Root 用户配置 ---
  users.users.root = {
    # 注意：这是 "initial" 密码，仅在第一次部署时生效。
    # 以后如果你用 passwd 命令改了密码，这个配置不会覆盖它（这是为了安全性）。
    # nix run nixpkgs#mkpasswd -- -m sha-512
    initialHashedPassword = "$6$DhwUDApjyhVCtu4H$mr8WIUeuNrxtoLeGjrMqTtp6jQeQIBuWvq/.qv9yKm3T/g5794hV.GhG78W2rctGDaibDAgS9X9I9FuPndGC01";

    # 2. 设置 SSH 公钥
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBaNS9FByCEaDjPOUpeQZg58zM2wD+jEY6SkIbE1k3Zn ed25519 256-20251206 shaog@duck.com"
    ];
  };

  # --- SSH 安全加固 (配合使用) ---
  services.openssh = {
    settings = {
      # 禁止 Root 密码登录
      PermitRootLogin = "prohibit-password"; 
      
      # 禁止空密码
      PermitEmptyPasswords = "no";
    };
  };
}