#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'
CYAN='\033[0;36m'

echo " ====== Browser Overlay Installer ======"

if command -v python3 &>/dev/null; then
    PYTHON_BIN="python3"
elif command -v python &>/dev/null; then
    PYTHON_BIN="python"
else
    echo -e "${RED}ERROR: Python is not installed.${NC}"
    echo "Install it via your distro package manager:"
    echo "  Debian: sudo apt install python3"
    echo "  Arch Linux: sudo pacman -S python"
    echo "  Fedora: sudo dnf install python3"
    exit 1
fi

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    "$PYTHON_BIN" -m venv venv
else
    echo "Virtual environment already exists."
fi

FULL_PATH="$(pwd)/venv/bin/python"

"$FULL_PATH" - <<'EOF'
import sys
try:
    import pip
except ImportError:
    print("ERROR: pip is not installed in this virtual environment.")
    print("You can try to fix this by running:")
    print(f"  {sys.executable} -m ensurepip")
    print("Or manually via:")
    print("  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py")
    print(f"  {sys.executable} get-pip.py")
    sys.exit(1)
EOF

echo "Installing required Python packages..."
"$FULL_PATH" -m pip install --upgrade pip
"$FULL_PATH" -m pip install -r requirements.txt

INSTALL_DIR="$HOME/.local/bin"
LAUNCHER_FILE="$(pwd)/browser-overlay"
LAUNCHER_LINK="$INSTALL_DIR/browser-overlay"

chmod +x "$LAUNCHER_FILE"
mkdir -p "$INSTALL_DIR"

if [ -L "$LAUNCHER_LINK" ] || [ -e "$LAUNCHER_LINK" ]; then
    echo "Updating existing Browser Overlay entry in $INSTALL_DIR..."
    ln -sf "$LAUNCHER_FILE" "$LAUNCHER_LINK"
else
    ln -sf "$LAUNCHER_FILE" "$LAUNCHER_LINK"
    echo -e "${GREEN}Browser Overlay added to $INSTALL_DIR${NC}"
fi
case ":$PATH:" in
    *":$INSTALL_DIR:"*)
        ;;
    *)
        echo
        echo -e "${YELLOW}$INSTALL_DIR is not in your PATH.${NC}"
        echo "Add this line to your shell config (~/.bashrc, ~/.zshrc, etc.):"
        echo
        echo -e "  ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
        echo
        echo "Then restart your terminal."
        ;;
esac

echo
echo -e "${GREEN}Installation complete!${NC}"
echo

echo "To run Browser Overlay:"
echo -e "  ${CYAN}browser-overlay${NC}"
echo
echo "To uninstall Browser Overlay, run:"
echo -e "  ${CYAN}./uninstall.sh${NC}"
echo
echo "To configure Browser Overlay, run the program, then edit ~/.config/browser-overlay/config.toml."
echo
