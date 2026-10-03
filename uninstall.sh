#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo " ====== Browser Overlay Uninstaller ======"
echo

INSTALL_DIR="$HOME/.local/bin"
LAUNCHER_LINK="$INSTALL_DIR/browser-overlay"

if [ -L "$LAUNCHER_LINK" ]; then
    rm "$LAUNCHER_LINK"
    echo -e "${GREEN}Removed Browser Overlay from $INSTALL_DIR${NC}"
elif [ -e "$LAUNCHER_LINK" ]; then
    echo -e "${YELLOW}$LAUNCHER_LINK exists but is not a symlink. Removing anyway...${NC}"
    rm "$LAUNCHER_LINK"
    echo -e "${GREEN}Removed.${NC}"
else
    echo -e "${YELLOW}Browser Overlay was not found in $INSTALL_DIR. Nothing to remove.${NC}"
fi

echo
echo "Note: This only removes the terminal command."
echo "The Browser Overlay directory nor config folder was removed."
