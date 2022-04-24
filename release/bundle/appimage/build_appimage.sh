#!/usr/bin/env bash
# Copyright 2019-2021 Tauri Programme within The Commons Conservancy
# SPDX-License-Identifier: Apache-2.0
# SPDX-License-Identifier: MIT

set -euxo pipefail

export ARCH=x86_64

mkdir -p "tauri-app.AppDir"
cp -r ../appimage_deb/data/usr "tauri-app.AppDir"

cd "tauri-app.AppDir"

# Copy WebKit files.
find /usr/lib* -name WebKitNetworkProcess -exec mkdir -p "$(dirname '{}')" \; -exec cp --parents '{}' "." \; || true
find /usr/lib* -name WebKitWebProcess -exec mkdir -p "$(dirname '{}')" \; -exec cp --parents '{}' "." \; || true
find /usr/lib* -name libwebkit2gtkinjectedbundle.so -exec mkdir -p "$(dirname '{}')" \; -exec cp --parents '{}' "." \; || true

wget -q -4 -O AppRun https://github.com/AppImage/AppImageKit/releases/download/continuous/AppRun-x86_64 || wget -q -4 -O AppRun https://github.com/AppImage/AppImageKit/releases/download/12/AppRun-aarch64
chmod +x AppRun

cp "usr/share/icons/hicolor/512x512@2x/apps/tauri-app.png" .DirIcon
ln -s "usr/share/icons/hicolor/512x512@2x/apps/tauri-app.png" "tauri-app.png"

ln -s "usr/share/applications/tauri-app.desktop" "tauri-app.desktop"

cd ..

wget -q -4 -O linuxdeploy-plugin-gtk.sh "https://raw.githubusercontent.com/tauri-apps/linuxdeploy-plugin-gtk/master/linuxdeploy-plugin-gtk.sh"
wget -q -4 -O linuxdeploy-x86_64.AppImage https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage

chmod +x linuxdeploy-plugin-gtk.sh
chmod +x linuxdeploy-x86_64.AppImage

OUTPUT="tauri-app_0.1.0_aarch64.AppImage" ./linuxdeploy-x86_64.AppImage --appimage-extract-and-run --appdir "tauri-app.AppDir" --plugin gtk --output appimage
