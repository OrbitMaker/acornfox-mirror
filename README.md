# acornfox-mirror（测试）

这个仓库存放 AcornFox 安装程序要用到的**第三方安装文件的原样副本**，方便国内网络下载。我们不修改这些文件；每个文件的原始地址和官方 SHA256 都写在 `files.txt` 里，发行版附件里的 `SHA256SUMS` 可以用来核对。

| 文件 | 原始地址 | 许可证 |
|---|---|---|
| `wsl.3.0.3.0.x64.msi` | github.com/microsoft/WSL 发行版 3.0.3 | 见原仓库 LICENSE 和发行说明 |
| `Debian_WSL_AMD64_v1.26.0.0.wsl` | salsa.debian.org/debian/WSL | Debian 各软件包各自的自由软件许可证；源码见 Debian 官方 |

- 超过 90 MB 的文件另外切成 `.part00`、`.part01`… 若干段，用 `cat 名称.part* > 名称` 拼回，再用 `SHA256SUMS` 核对。
- 文件由 GitHub Actions（`.github/workflows/fetch.yml`）从原始地址下载、核对后发布，不经过我们自己的机器。
- 目前是测试用途，内容和地址可能变动。
