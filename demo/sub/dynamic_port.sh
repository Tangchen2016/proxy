# 动态端口映射
port=$1

# 删除之前的PREROUTING规则
rules=$(sudo iptables -t nat -L PREROUTING --line-numbers -n -v)
# 按行遍历规则内容
while IFS= read -r line; do
    # 检查该行规则是否涉及目标端口在10000 - 30000范围（针对TCP协议，可按需增加UDP等其他协议判断）
    if echo "$line" | grep -q "tcp" && echo "$line" | grep -q "dpts:10000:30000"; then
        rule_number=$(echo "$line" | awk '{print $1}')
        # 根据规则行号删除对应的规则
        sudo iptables -t nat -D PREROUTING $rule_number
    fi
done <<< "$rules"

# 更新动态端口
iptables -t nat -A PREROUTING -p tcp --dport 10000:30000 -j REDIRECT --to-ports $port
