#!/bin/sh
script_path=$0
current_dir=$(dirname "$script_path")
remote_path=root@$ip:/root/nodes/

region=$(curl -s ipinfo.io | jq -r '.region | gsub(" "; "_")')

# 查询trojan配置并写入nodes.conf文件
CONFIG_FILE=/usr/local/etc/trojan/config.json

domain=$(grep sni $CONFIG_FILE | cut -d: -f2 | tr -d \",' ')
if [ "$domain" = "" ]; then
  domain=$(grep -m1 cert $CONFIG_FILE | cut -d/ -f5)
fi

port=$(grep local_port $CONFIG_FILE | cut -d: -f2 | tr -d \",' ')
line1=$(grep -n 'password' $CONFIG_FILE | head -n1 | cut -d: -f1)
line11=$(expr $line1 + 1)
password=$(sed -n "${line11}p" $CONFIG_FILE | tr -d \",' ')

echo $region $domain $port $password > $current_dir/$region.nodes.conf

# 绑定端口
bash $current_dir/dynamic_port.sh $port

scp $region.nodes.conf $remote_path
