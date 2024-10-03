# Radio List Manager Script

This script allows you to manage and play a list of online radio stations from the terminal. It features the ability to display a list of saved radio stations, add new ones, delete stations, and play selected stations using the `mpv` media player.

## Features

- Add new radio stations by providing a name and URL.
- Delete existing radio stations from the list.
- Navigate through the list using arrow keys.
- Play selected radio stations using `mpv`.
- The list of radio stations is saved in a file (`radio.lis`), so it's persistent between runs.

## How to Use

1. **Initial Setup**:
   If the `radio.lis` file does not exist in the home directory, the script will automatically create a default file with three preset radio stations:

   - Gensokyo Radio
   - Vocaloid Radio
   - Vocaloid Radio CN

2. **Navigation**:

   - Use the **Up (↑)** and **Down (↓)** arrow keys to navigate through the list of radio stations.
   - The currently selected radio station will be highlighted in yellow.

3. **Play a Station**:

   - Press **Enter** to play the currently selected radio station using `mpv`.

4. **Add a Station**:

   - Press **A** to add a new radio station.
   - You will be prompted to enter the station's name and URL.

5. **Delete a Station**:

   - Press **D** to delete the currently selected radio station.
   - You will be asked for confirmation before the station is removed from the list.

6. **Exit the Script**:
   - Press **Q** to quit the script.

## Dependencies

- `mpv`: The script uses `mpv` to play the selected radio stations. Ensure `mpv` is installed on your system. You can install it via:
  ```bash
  sudo apt install mpv  # For Debian-based systems
  brew install mpv      # For macOS with Homebrew
  ```

## Example Radio List

If you run the script for the first time, it creates a `radio.lis` file with the following content:

```
[Gensokyo Radio]https://stream.gensokyoradio.net/3
[Vocaloid Radio]https://vocaloid.radioca.st/stream
[Vocaloid Radio CN]http://curiosity.shoutca.st:8019/stream
```

You can modify this file manually or use the script to manage the entries.

## Notes

- The `radio.lis` file should be located in your home directory (`~/radio.lis`).
- The script updates this file automatically when you add or delete a station.

## Customization

You can modify the `radio.lis` file directly to add or change radio stations. Each line should follow this format:

```
[Station Name]Station URL
```

Enjoy your personalized radio manager!
