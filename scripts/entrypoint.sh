#!/bin/bash
set -e
export TZ="${GNP_TZ:-Europe/Paris}"
export HOME=/home/gnp
export WINEPREFIX="${WINEPREFIX:-/opt/wine}"
export DISPLAY="${DISPLAY:-:99}"
mkdir -p /opt/steam /opt/games/server /opt/games/config /opt/games/saves /opt/games/backups "$WINEPREFIX"
chown -R gnp:gnp /opt/steam /opt/games "$WINEPREFIX" /home/gnp || true
if ! pgrep -f "Xvfb ${DISPLAY}" >/dev/null 2>&1; then
    Xvfb "${DISPLAY}" -screen 0 1024x768x16 >/tmp/xvfb.log 2>&1 &
    sleep 2
fi
echo "============================================================"
echo "🌲 GameNodePanel - Sons Of The Forest Docker Image"
echo "============================================================"
echo "🏷️  Nom serveur : ${GNP_SERVER_NAME:-GNP_SOTF_Server}"
echo "👥 Joueurs     : ${GNP_MAX_PLAYERS:-8}"
echo "🌐 Game Port   : ${GNP_GAME_PORT:-8766}/udp"
echo "🔎 Query Port  : ${GNP_QUERY_PORT:-27016}/udp"
echo "🧩 Blob Port   : ${GNP_BLOB_SYNC_PORT:-9700}/udp"
echo "💾 UserData    : /opt/games/config"
echo "🍷 Wineprefix  : ${WINEPREFIX}"
echo "============================================================"
if [ ! -x /opt/steam/steamcmd.sh ]; then
    gosu gnp /scripts/install-steamcmd.sh
fi
if [ "${GNP_GAME_UPDATE:-true}" = "true" ] || [ ! -f /opt/games/server/SonsOfTheForestDS.exe ]; then
    gosu gnp /scripts/install-sotf.sh
fi
if [ ! -f "${WINEPREFIX}/.gnp_wine_ready" ]; then
    gosu gnp /scripts/prepare-wine.sh
fi
gosu gnp /scripts/write-config.sh
exec gosu gnp /scripts/start-server.sh
