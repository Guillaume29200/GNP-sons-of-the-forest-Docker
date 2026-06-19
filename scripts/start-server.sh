#!/bin/bash
set -e
export HOME=/home/gnp
export WINEPREFIX="${WINEPREFIX:-/opt/wine}"
export DISPLAY="${DISPLAY:-:99}"
export WINEDEBUG="${WINEDEBUG:--all}"
SERVER_DIR="/opt/games/server"
CONFIG_DIR="/opt/games/config"
EXTRA_ARGS="${GNP_EXTRA_ARGS:-}"
VERBOSE="${GNP_VERBOSE_LOGGING:-false}"
FILTER_LOGS="${GNP_FILTER_WINE_LOGS:-true}"
cd "$SERVER_DIR"
if [ ! -f "SonsOfTheForestDS.exe" ]; then
    echo "❌ SonsOfTheForestDS.exe introuvable dans ${SERVER_DIR}"
    exit 1
fi
ARGS=("SonsOfTheForestDS.exe" -userdatapath "Z:${CONFIG_DIR}")
if [ "$VERBOSE" = "true" ]; then ARGS+=( -verboseLogging ); fi
if [ -n "$EXTRA_ARGS" ]; then
    # shellcheck disable=SC2206
    EXTRA_ARRAY=( $EXTRA_ARGS )
    ARGS+=( "${EXTRA_ARRAY[@]}" )
fi
echo "🚀 Lancement Sons Of The Forest Dedicated Server..."
echo "📁 UserData : ${CONFIG_DIR}"
echo "📄 Config   : ${CONFIG_DIR}/dedicatedserver.cfg"
touch /opt/games/config/server.log
if [ "$FILTER_LOGS" = "true" ]; then
    exec wine "${ARGS[@]}" 2>&1 | grep -vE "fixme:|WARNING: Shader|Shader .* not supported|No mesh data available|Couldn.t create a Convex Mesh|winediag:" | tee -a /opt/games/config/server.log
else
    exec wine "${ARGS[@]}" 2>&1 | tee -a /opt/games/config/server.log
fi
