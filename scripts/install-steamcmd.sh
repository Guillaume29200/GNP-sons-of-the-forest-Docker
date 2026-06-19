#!/bin/bash
set -e
STEAM_DIR="/opt/steam"
mkdir -p "$STEAM_DIR"
cd "$STEAM_DIR"
echo "🔄 Installation SteamCMD..."
curl -L --fail -o steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzf steamcmd_linux.tar.gz
rm -f steamcmd_linux.tar.gz
echo "✅ SteamCMD installé dans ${STEAM_DIR}."
