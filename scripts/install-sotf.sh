#!/bin/bash
set -e
STEAMCMD="/opt/steam/steamcmd.sh"
SERVER_DIR="/opt/games/server"
APP_ID="${GNP_STEAM_APP_ID:-2465200}"
STEAM_USER="${GNP_STEAM_USER:-anonymous}"
STEAM_PASSWORD="${GNP_STEAM_PASSWORD:-}"
STEAM_AUTH="${GNP_STEAM_AUTH:-}"
BETA="${GNP_STEAM_BETA:-}"
BETA_PASSWORD="${GNP_STEAM_BETA_PASSWORD:-}"
mkdir -p "$SERVER_DIR" /opt/games/config /opt/games/saves
LOGIN_ARGS=(+login "$STEAM_USER")
if [ "$STEAM_USER" != "anonymous" ]; then
    LOGIN_ARGS=(+login "$STEAM_USER" "$STEAM_PASSWORD" "$STEAM_AUTH")
fi
UPDATE_ARGS=(+app_update "$APP_ID")
if [ -n "$BETA" ]; then UPDATE_ARGS+=( -beta "$BETA" ); fi
if [ -n "$BETA_PASSWORD" ]; then UPDATE_ARGS+=( -betapassword "$BETA_PASSWORD" ); fi
UPDATE_ARGS+=( validate )
PLATFORM_ARGS=()
if [ "${GNP_FORCE_PLATFORM_WINDOWS:-true}" = "true" ]; then
    PLATFORM_ARGS=(+@sSteamCmdForcePlatformType windows)
fi
echo "🔄 Installation / mise à jour Sons Of The Forest Dedicated Server via SteamCMD..."
echo "📦 AppID : ${APP_ID}"
echo "⚠️ Le serveur dédié officiel est Windows : exécution via Wine dans Docker."
"$STEAMCMD" +force_install_dir "$SERVER_DIR" "${PLATFORM_ARGS[@]}" "${LOGIN_ARGS[@]}" "${UPDATE_ARGS[@]}" +quit
if [ ! -f "$SERVER_DIR/SonsOfTheForestDS.exe" ]; then
    echo "❌ SonsOfTheForestDS.exe introuvable après installation."
    echo "➡️ Vérifie SteamCMD/AppID ou les droits du dépôt."
    exit 1
fi
mkdir -p "$SERVER_DIR/.steam/sdk32" "$SERVER_DIR/.steam/sdk64"
cp -f /opt/steam/linux32/steamclient.so "$SERVER_DIR/.steam/sdk32/steamclient.so" 2>/dev/null || true
cp -f /opt/steam/linux64/steamclient.so "$SERVER_DIR/.steam/sdk64/steamclient.so" 2>/dev/null || true
echo "✅ Sons Of The Forest Dedicated Server installé / mis à jour."
