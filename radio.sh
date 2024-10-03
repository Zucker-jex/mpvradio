#!/bin/bash

LIST_FILE=~/radio.lis

# Check if the default radio list file exists, if not, create it
if [ ! -f "$LIST_FILE" ]; then
    echo "[Gensokyo Radio]https://stream.gensokyoradio.net/3" > "$LIST_FILE"
    echo "[Vocaloid Radio]https://vocaloid.radioca.st/stream" >> "$LIST_FILE"
    echo "[Vocaloid Radio CN]http://curiosity.shoutca.st:8019/stream" >> "$LIST_FILE"
fi

# Read the radio list and display it
read_radio_list() {
    mapfile -t radios < "$LIST_FILE"
}

# Display the radio list menu
draw_menu() {
    tput clear
    echo "=========== Radio List ==========="
    for i in "${!radios[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            tput setaf 3 # Set text color to yellow
            echo "> $(echo "${radios[$i]}" | cut -d']' -f1 | tr -d '[')"
            tput sgr0 # Reset text color
        else
            echo "  $(echo "${radios[$i]}" | cut -d']' -f1 | tr -d '[')"
        fi
    done
    echo "=================================="
    echo "↑/↓: Move up/down A: Add radio D: Delete radio Q: Quit"
}

# Add a radio
add_radio() {
    echo "Please enter radio title:"
    read -r title
    echo "Please enter radio URL:"
    read -r url
    echo "[$title]$url" >> "$LIST_FILE"
    echo "Radio added: $title"
    read_radio_list
}

# Delete a radio
delete_radio() {
    selected_radio="${radios[$selected]}"
    radio_name=$(echo "$selected_radio" | cut -d']' -f1 | tr -d '[')

    # Confirm deletion
    echo "Are you sure you want to delete radio '$radio_name'? (y/n)"
    read -r confirmation
    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
        # Use sed to delete the selected radio, the index starts from 1 so we need +1
        sed -i "$((selected + 1))d" "$LIST_FILE"
        echo "Radio '$radio_name' deleted"
        read_radio_list

        # Adjust the selection
        if [ "$selected" -ge "${#radios[@]}" ]; then
            selected=$((${#radios[@]} - 1))
        fi
    else
        echo "Deletion cancelled"
    fi
}

# Play a radio
play_radio() {
    selected_radio="${radios[$selected]}"
    radio_name=$(echo "$selected_radio" | cut -d']' -f1 | tr -d '[')
    radio_url=$(echo "$selected_radio" | cut -d']' -f2)

    echo "Now playing: $radio_name"

    # Use mpv to play
    mpv --no-video "$radio_url"
}

# Main loop
read_radio_list
selected=0
while true; do
    draw_menu

    read -rsn1 key

    case "$key" in
        $'\x1B')
            read -rsn2 key
            if [[ "$key" == "[A" ]]; then # Up arrow
                ((selected--))
                if [ "$selected" -lt 0 ]; then
                    selected=$((${#radios[@]} - 1))
                fi
            elif [[ "$key" == "[B" ]]; then # Down arrow
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
            echo "Goodbye!"
            exit 0
            ;;
    esac
done