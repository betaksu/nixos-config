# NixOS Configuration Library

> **Note**: 当前库是个人配置文件库。若希望寻找模板库方便配置 NixOS，请前往 [https://github.com/ShaoG-R/nixos-config-template](https://github.com/ShaoG-R/nixos-config-template)。

欢迎来到我的个人 NixOS 配置文件库。本项目旨在为 VPS 和服务器提供一套高性能、模块化且易于维护的 NixOS 配置方案。

## 📖 文档指南

- **[安装与部署指南](docs/install.md)**: 包含多种安装方式（一键 DD、Anywhere、手动安装）。
- **[如何创建自己的主机配置](docs/create_your_own_host.md)**: 了解如何添加和定制新的服务器。

## 🏗️ 架构设计

本配置库采用了 **机制 (Mechanism) 与 策略 (Strategy) 分离** 的设计思想，确保配置的高度复用性和灵活性。

### 核心机制 (`server/vps.nix`)
`mkSystem` 函数封装了构建 NixOS 系统的通用逻辑。它并不关心具体开启了哪些服务，而是提供了一个标准的接口来接收配置：
- `system`: 目标系统架构 (如 `x86_64-linux`)。
- `diskDevice`: 目标磁盘设备。
- `extraModules`: 一个模块列表，用于定义该主机特有的功能（策略）。

### 策略实现 (`server/vps/*.nix`)
每个主机配置文件（如 `server/vps/tohu.nix`）代表一种具体的策略。它通过组合不同的模块来定义服务器的角色和功能。

例如，`tohu` 主机的定义：
```nix
mkSystem {
  # ...
  extraModules = [
    ./platform/generic.nix             # 通用基础配置
    ./kernel/cachyos.nix               # 高性能内核
    ./services/dns/smartdns-oversea.nix # DNS 优化
    ./profiles/memory/aggressive.nix   # 内存激进优化
    ./software/web/alist.nix           # 具体业务服务
    # ...
  ];
}
```

## ✨ 关键特性模块

本库包含多个精心调优的模块，开箱即用：

### 🚀 高性能内核与网络 (`server/vps/kernel/cachyos.nix`)
- **CachyOS 内核**: 采用 CachyOS 优化的内核，提供更好的调度性能。
- **BBRv3 + CAKE**:默认启用 BBRv3 拥塞控制算法配合 CAKE 队列管理，显著降低 bufferbloat，提升弱网环境下的吞吐量和延迟表现。
- **TCP 协议栈调优**: 针对现代网络环境优化了 TCP 窗口大小、Fast Open、连接追踪表等参数。

### 🌐 DNS 优化 (`server/vps/services/dns/smartdns-oversea.nix`)
- **SmartDNS**: 使用 SmartDNS 作为本地 DNS 解析器。
- **并行查询与测速**: 并发查询多个上游 DNS（如 Cloudflare, Google, Quad9），并基于 ping 和 tcp 握手进行测速，自动选择最快的 IP 地址返回。
- **持久化缓存**: 配置了激进的缓存策略和预取功能，极大减少 DNS 查询延迟。

### 💾 内存优化 (`server/vps/profiles/memory/aggressive.nix`)
- **ZRAM**: 针对小内存 VPS（如 1GB 甚至更小），启用了激进的 ZRAM 策略 (`zstd` 压缩)，将内存当做高速 Swap 使用。
- **内核参数调优**: 调整 `vm.swappiness` 和 `vm.vfs_cache_pressure`，倾向于保留文件缓存并积极使用 ZRAM，配合 MGLRU 算法，防止系统在内存压力大时假死。

### 🐳 容器化支持 (`server/vps/software/container/podman.nix`)
- **Podman**: 默认使用 Podman 替代 Docker，提供更轻量级的容器运行环境。
- **OCI Containers**: 通过 NixOS 模块声明式管理容器（如 AList），支持自动启动、卷挂载和网络配置。

### 🔒 安全与认证 (`server/vps/auth/default.nix`)
- **声明式凭证**: Root 密码和 SSH 公钥通过 Nix 配置文件统一管理，部署即生效。
- **SSH 加固**: 默认仅允许 Key 登录，禁用空密码，符合安全最佳实践。

### 🛠️ 自动化分区 (`server/vps/disk/common.nix`)
- **Disko 集成**: 使用 Disko 声明磁盘分区结构（GPT, ESP, Btrfs subvolumes, Swap），实现一键分区和格式化。
- **Btrfs**: 根分区采用 Btrfs，并配置了 zstd 压缩，节省磁盘空间并提升读写寿命。