# Browser Overlay

> [!IMPORTANT]
> This program works **only on Linux**.

A program that displays a website in an always-on-top window. This is mainly useful for **single-monitor** users, but also helpful for those with a second monitor.

If you only want Twitch chat, you can use [Twitch Chat Overlay](https://github.com/qMaxXen/twitch-chat-overlay) which is more minimal and lightweight. If you want more customization of the chat, use this program with a link generated with [crazysmc's tchat generator](https://crazysmc.github.io/tchat.html).

## Installation

1. Go to the [releases](https://github.com/qMaxXen/browser-overlay/releases/latest) section of this repository and download `browser-overlay-v1.0.0.tar.xz`.

2. Move the downloaded file to a convenient folder, then extract it using the terminal with the following command:

   ```bash
   tar -xf browser-overlay-v1.0.0.tar.xz
   ```
3. Install the required Python packages to run the program:

   ```bash
   cd browser-overlay-v1.0.0
   chmod +x install.sh
   ./install.sh
   ```
4. To run it, type:
   ```bash
   browser-overlay
   ```
   To configure it, edit `~/.config/browser-overlay/config.toml`.

## Features

- A website displayed in an always-on-top window, even over fullscreen applications
- You can have as many windows with different websites as you want
- Custom css
- Configurable window size and position
- Click-through option
- Automatically checks for updates and offers to update to the latest version

## License
Browser Overlay is licensed under the MIT license. You can view the full license [here](https://github.com/qMaxXen/browser-overlay/blob/main/LICENSE).

---

If you have any issues, feel free to ask for help by creating a thread in the [Linux MCSR Discord server](https://discord.gg/3tm4UpUQ8t).
