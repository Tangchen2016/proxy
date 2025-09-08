# 科学上网（支持主备机）

推荐：Ubuntu系统


## 主机
### 准备
- VPS
- 域名
- DNS解析


### 下载配置

``` bash
curl https://raw.githubusercontent.com/Tangchen2016/proxy/refs/heads/main/install | bash
```

### 运行
```bash
sh setup.sh
```

### 卸载
```bash
curl https://raw.githubusercontent.com/Tangchen2016/proxy/refs/heads/main/uninstall | bash
```

## 备机
### 准备
- 主机IP
- VPS
- 域名
- DNS解析

### 下载配置

```bash
curl https://raw.githubusercontent.com/Tangchen2016/proxy/refs/heads/main/install_sub -s {ip} | bash
```

### 运行
```bash
sh setup.sh
```

### 卸载
```bash
curl https://raw.githubusercontent.com/Tangchen2016/proxy/refs/heads/main/uninstall_sub | bash
```

# VPS
[akile](https://akile.io/shop/server/)

[vollcloud](https://vollcloud.com/store/hong-kong-cmi-vps-sale)

# 域名
[namesilo](https://www.namesilo.com/)
