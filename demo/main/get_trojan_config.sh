#!/bin/bash

# 获取trojan配置

script_path=$0
current_dir=$(dirname "$script_path")

# 定义函数，用于读取并解析 ./nodes/ 目录下所有 .nodes.conf 文件，并返回解析后的数据
read_config_file() {
    local result=()  # 初始化一个空数组，用于存储解析后的配置信息
    local nodes_dir="$current_dir/nodes"

    # 检查 nodes 目录是否存在
    if [ -d "$nodes_dir" ]; then
        # 遍历 ./nodes/ 目录下所有以 .nodes.conf 结尾的文件
        for file_path in "$nodes_dir"/*.nodes.conf; do
            if [ -f "$file_path" ]; then
                # 使用 sed 将文件中的换行符替换为特殊字符（这里用 @），方便后续处理
                local temp=$(sed 's/$/@/' "$file_path")
                # 以 @ 为分隔符，循环处理每一段内容（对应原文件的每行内容）
                while IFS='@' read -r line; do
                    # 判断该行是否为注释行，如果以 # 开头则跳过
                    if [[ $line =~ ^# ]]; then
                        continue
                    fi
                    local node_name=$(echo "$line" | cut -d' ' -f1)
                    local host=$(echo "$line" | cut -d' ' -f2)
                    local port=$(echo "$line" | cut -d' ' -f3)
                    local password=$(echo "$line" | cut -d' ' -f4)
                    # 将每行解析出的配置信息作为一个子数组添加到 result 数组中
                    result+=("$node_name" "$host" "$port" "$password")
                done <<< "$temp"
            else
                echo "文件 $file_path 不存在，跳过该文件。" >&2
            fi
        done
    else
        echo "目录 $nodes_dir 不存在。" >&2
    fi
    echo "${result[@]}"  # 返回存储配置信息的数组
}
