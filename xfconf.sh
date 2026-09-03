#!/bin/bash

xfconf-query -c thunar -p /misc-middle-click-in-tab -s true -nt bool
xfconf-query -c thunar -p /misc-text-beside-icons -s true -nt bool

xfconf-query -c xfce4-appfinder -p /close-on-focus-lost -s true -nt bool

# Hide desktop icons
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0 -nt int

xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt>b' -s 'exo-open --launch WebBrowser' -nt string
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt>v' -s 'xfce4-clipman-history' -nt string

xfconf-query -c xfce4-notifyd -p /do-slideout -s true -nt bool
xfconf-query -c xfce4-notifyd -p /expire-timeout -s 5 -nt int
xfconf-query -c xfce4-notifyd -p /notify-location -s bottom-right -nt string

# Mouse selection can also be pasted as stack top
xfconf-query -c xfce4-panel -p /plugins/clipman/settings/add-primary-clipboard -s true -nt bool
# Save mouse selection in history (Default is true, diffrent from web document)
xfconf-query -c xfce4-panel -p /plugins/clipman/settings/history-ignore-primary-clipboard -s false -nt bool
xfconf-query -c xfce4-panel -p /plugins/clipman/settings/max-images-in-history -s 3 -nt uint
# Paste when pick history
xfconf-query -c xfce4-panel -p /plugins/clipman/tweaks/paste-on-activate -s 2 -nt uint

# Bottom blue from palette
xfconf-query -c xfce4-terminal -p /color-cursor -s '#1a1a5f5fb4b4' -nt string
xfconf-query -c xfce4-terminal -p /color-cursor-use-default -s false -nt bool
# Preset Tango
xfconf-query -c xfce4-terminal -p /color-palette -s '#000000;#cc0000;#4e9a06;#c4a000;#3465a4;#75507b;#06989a;#d3d7cf;#555753;#ef2929;#8ae234;#fce94f;#739fcf;#ad7fa8;#34e2e2;#eeeeec' -nt string
xfconf-query -c xfce4-terminal -p /misc-copy-on-select -s true -nt bool
xfconf-query -c xfce4-terminal -p /misc-default-geometry -s 105x47 -nt string
xfconf-query -c xfce4-terminal -p /scrolling-bar -s TERMINAL_SCROLLBAR_NONE -nt string
xfconf-query -c xfce4-terminal -p /text-blink-mode -s TERMINAL_TEXT_BLINK_MODE_NEVER -nt string

xfconf-query -c xfwm4 -p /general/theme -s Default-hdpi -nt string
# Focus follow mouse
xfconf-query -c xfwm4 -p /general/click_to_focus -s false -nt bool
# Focus follow mouse delay
xfconf-query -c xfwm4 -p /general/focus_delay -s 5 -nt int
# Snap other windows
xfconf-query -c xfwm4 -p /general/snap_to_windows -s true -nt bool
xfconf-query -c xfwm4 -p /general/snap_width -s 16 -nt int
# No wrap workspaces while dragging windows
xfconf-query -c xfwm4 -p /general/wrap_windows -s false -nt bool
xfconf-query -c xfwm4 -p /general/move_opacity -s 60 -nt int
xfconf-query -c xfwm4 -p /general/resize_opacity -s 60 -nt int

xfconf-query -c xsettings -p /Net/ThemeName -s Adwaita-dark -nt string
xfconf-query -c xsettings -p /Xft/DPI -s 135 -nt int


# Set user by default in the login menu
sudo sed -Ei 's/^#(greeter-hide-users=false)/\1/' /etc/lightdm/lightdm.conf

# Set Input Method ON/OFF key on uim-pref-gtk3
# 全体キー設定1
# Mozc key bindings

# Autostart applications
# Enable Clipman if not pinned to dock

sudo tee /etc/udev/hwdb.d/71-mouse-local.hwdb >/dev/null <<EOF
mouse:usb:v04a5p800a:*
mouse:usb:v04a5p8006:*
 KEYBOARD_KEY_90004=btn_middle
EOF
sudo tee /etc/udev/rules.d/99-mouse-remap.rules >/dev/null <<EOF
SUBSYSTEM=="input", ATTRS{idVendor}=="04a5", ATTRS{idProduct}=="800[a6]", IMPORT{builtin}="keyboard"
EOF
sudo tee /etc/udev/hwdb.d/61-keyboard-local.hwdb >/dev/null <<EOF
evdev:atkbd:dmi:*
 KEYBOARD_KEY_3a=leftctrl
EOF
sudo systemd-hwdb update
sudo udevadm control --reload
sudo udevadm trigger
