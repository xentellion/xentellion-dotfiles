import Quickshell.Hyprland

GlobalShortcut {
    name: "toggleMenu"
    appid: "quickshell"
    description: "Toggles side menu"

    onPressed: {
        States.menuOpen = !States.menuOpen;
    }
}
