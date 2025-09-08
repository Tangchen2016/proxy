script_path=$0
current_dir=$(dirname "$script_path")

region=$(curl -s ipinfo.io | jq -r '.region | gsub(" "; "_")')

kill_process_by_port() {
    local port="$1"
    # 查找占用指定端口的进程的PID（进程标识符）
    local pids=$(lsof -i :$port | grep LISTEN | awk '{print $2}')
    if [ -n "$pids" ]; then
        echo "找到占用端口 $port 的进程，PID为：$pids，即将杀掉这些进程。"
        echo $pids | xargs kill -9
        echo "已杀掉占用端口 $port 的进程。"
    else
        echo "没有发现占用端口 $port 的进程。"
    fi
}

# 查询trojain配置并写入nodes.conf文件
CONFIG_FILE=/usr/local/etc/trojan/config.json

domain=$(grep sni $CONFIG_FILE | cut -d: -f2 | tr -d \",' ')
if [[ "$domain" = "" ]]; then
  domain=$(grep -m1 cert $CONFIG_FILE | cut -d/ -f5)
fi

port=$(grep local_port $CONFIG_FILE | cut -d: -f2 | tr -d \",' ')
line1=$(grep -n 'password' $CONFIG_FILE | head -n1 | cut -d: -f1)
line11=$(expr $line1 + 1)
password=$(sed -n "${line11}p" $CONFIG_FILE | tr -d \",' ')

echo $region $domain $port $password > $current_dir/nodes/$region.nodes.conf

# 杀掉proxy 8080端口进程
kill_process_by_port 8080

# 重启proxy
$current_dir/proxy.sh

# 绑定端口
$current_dir/dynamic_port.sh $port
