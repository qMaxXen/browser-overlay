from signal import SIG_DFL, SIGINT, signal
from PySide6.QtWidgets import QApplication
from PySide6.QtWebEngineWidgets import QWebEngineView
from PySide6.QtCore import QUrl, Qt
import os
from pathlib import Path
import tomllib
from PySide6.QtWebEngineCore import QWebEngineScript
import json
from PySide6.QtGui import QColor

config_file = Path.home() / ".config" / "browser-overlay" / "config.toml"
windows = []

default_config = """\
# You can always delete this config file to regenerate the default config by running the program

[[window]]
enabled = true
url = "https://example.com" # url of website
custom_css = "style.css" # assumes the directory of the main script, set to "" to disable
width = 1280 # width of window
height = 720 # height of window
click_through = false # makes the window click-through
x = 100
y = 100

# You can make as many windows as you want by copying the config snippet below

[[window]]
enabled = false
url = "https://example.com"
custom_css = "style.css"
width = 1280
height = 720
click_through = false
x = 100
y = 100
"""

def read_config():
    if config_file.exists():
        config = tomllib.loads(config_file.read_text())
        return config
    else:
        config_file.parent.mkdir(parents=True, exist_ok=True)
        config_file.write_text(default_config)
        config = tomllib.loads(config_file.read_text())
        return config

def read_css(file_name):
    if not file_name:
        return ""
    css_file = Path(__file__).parent / file_name
    if not css_file.exists():
        return ""
    print("Using", css_file)
    return css_file.read_text()

def add_css(window, css):
    js = (
        "(function() {"
        "const style = document.createElement('style');"
        "style.textContent = " + json.dumps(css) + ";"
        "document.head.appendChild(style);"
        "})();"
    )
    script = QWebEngineScript()
    script.setName("custom_css")
    script.setSourceCode(js)
    script.setInjectionPoint(QWebEngineScript.InjectionPoint.DocumentReady)
    script.setWorldId(QWebEngineScript.ScriptWorldId.ApplicationWorld)
    script.setRunsOnSubFrames(True)
    window.page().scripts().insert(script)

def create_window(window_config):
    window = QWebEngineView()
    if window_config.get("click_through", False):
        window.setWindowFlags(Qt.WindowType.WindowTransparentForInput | Qt.WindowType.FramelessWindowHint | Qt.WindowType.WindowStaysOnTopHint | Qt.WindowType.Tool | Qt.WindowType.X11BypassWindowManagerHint)
    else:
        window.setWindowFlags(Qt.WindowType.FramelessWindowHint | Qt.WindowType.WindowStaysOnTopHint | Qt.WindowType.Tool | Qt.WindowType.X11BypassWindowManagerHint)
    window.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
    window.setAttribute(Qt.WidgetAttribute.WA_NoSystemBackground)
    window.resize(window_config.get("width", 1280), window_config.get("height", 720))
    window.move(window_config.get("x", 100), window_config.get("y", 100))
    custom_css = read_css(window_config.get("custom_css", ""))
    if custom_css:
        add_css(window, custom_css)
    window.page().setBackgroundColor(QColor(0, 0, 0, 0))
    window.load(QUrl(window_config["url"]))

    return window

if __name__ == "__main__":
    signal(SIGINT, SIG_DFL)
    os.environ["QT_QPA_PLATFORM"] = "xcb"

    print("Browser Overlay")
    print("To configure Browser Overlay, edit ~/.config/browser-overlay/config.toml")

    app = QApplication()

    config = read_config()
    for window_config in config["window"]:
        if not window_config.get("enabled", True):
            continue
        window = create_window(window_config)
        window.show()
        windows.append(window)
    app.exec()
