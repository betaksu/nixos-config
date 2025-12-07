{
  services.tuned.enable = true;
  # 针对 VPS 推荐 'virtual-guest' 或 'throughput-performance'

  environment.etc."tuned/active_profile".text = "virtual-guest"; 
}