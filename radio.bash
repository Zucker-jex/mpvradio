#!/bin/bash

LIST_FILE=~/radio.lis

# 检查是否有默认电台列表文件，如果没有则创建
if [ ! -f "$LIST_FILE" ]; then
    echo "[Gensokyo Radio]https://stream.gensokyoradio.net/3" > "$LIST_FILE"
    echo "[Vocaloid Radio]https://vocaloid.radioca.st/stream" >> "$LIST_FILE"
    echo "[Vocaloid Radio CN]http://curiosity.shoutca.st:8019/stream" >> "$LIST_FILE"
fi

# 读取电台列表并显示
read_radio_list() {
    mapfile -t radios < "$LIST_FILE"
}

# 显示电台列表的菜单
draw_menu() {
    tput clear
    echo "=========== 电台列表 ==========="
    for i in "${!radios[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            tput setaf 3 # 设置黄色字体
            echo "> $(echo "${radios[$i]}" | cut -d']' -f1 | tr -d '[')"
            tput sgr0 # 重置颜色
        else
            echo "  $(echo "${radios[$i]}" | cut -d']' -f1 | tr -d '[')"
        fi
    done
    echo "================================"
    echo "↑/↓: 上下选择 A: 添加电台 D: 删除电台 Q: 退出"
}

# 添加电台
add_radio() {
    echo "请输入电台标题:"
    read -r title
    echo "请输入电台URL:"
    read -r url
    echo "[$title]$url" >> "$LIST_FILE"
    echo "电台已添加: $title"
    read_radio_list
}

# 删除电台
delete_radio() {
    selected_radio="${radios[$selected]}"
    radio_name=$(echo "$selected_radio" | cut -d']' -f1 | tr -d '[')

    # 确认删除
    echo "确定要删除电台 '$radio_name' 吗？ (y/n)"
    read -r confirmation
    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
        # 使用 sed 删除选中的电台，索引从 1 开始，因此需要 +1
        sed -i "$((selected + 1))d" "$LIST_FILE"
        echo "电台 '$radio_name' 已删除"
        read_radio_list

        # 调整选择位置
        if [ "$selected" -ge "${#radios[@]}" ]; then
            selected=$((${#radios[@]} - 1))
        fi
    else
        echo "取消删除电台"
    fi
}

# 播放电台
play_radio() {
    selected_radio="${radios[$selected]}"
    radio_name=$(echo "$selected_radio" | cut -d']' -f1 | tr -d '[')
    radio_url=$(echo "$selected_radio" | cut -d']' -f2)

    echo "正在播放: $radio_name"

    # 使用 mpv 播放
    mpv --no-video "$radio_url"
}

# 主程序循环
read_radio_list
selected=0
while true; do
    draw_menu

    read -rsn1 key

    case "$key" in
        $'\x1B')
            read -rsn2 key
            if [[ "$key" == "[A" ]]; then # 向上箭头
                ((selected--))
                if [ "$selected" -lt 0 ]; then
                    selected=$((${#radios[@]} - 1))
                fi
            elif [[ "$key" == "[B" ]]; then # 向下箭头
                ((selected++))
                if [ "$selected" -ge "${#radios[@]}" ]; then
                    selected=0
                fi
            fi
            ;;
        "")
            play_radio
            ;;
        A|a)
            add_radio
            ;;
        D|d)
            delete_radio
            ;;
        Q|q)
            echo "再见！"
            exit 0
            ;;
    esac
done