{
  services.tuned.enable = true;
  # 针对 VPS 推荐 'virtual-guest' 或 'throughput-performance'
  services.tuned.profile = "virtual-guest"; 
}