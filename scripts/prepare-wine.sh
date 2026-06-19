#!/bin/bash
set -e
export HOME=/home/gnp
export WINEPREFIX="${WINEPREFIX:-/opt/wine}"
export DISPLAY="${DISPLAY:-:99}"
export WINEDEBUG="${WINEDEBUG:--all}"
mkdir -p "$WINEPREFIX"
echo "🍷 Préparation Wineprefix Sons Of The Forest..."
wineboot --init || true
sleep 3
if [ -n "${GNP_WINETRICKS_RUN:-}" ]; then
    echo "🍷 Winetricks : ${GNP_WINETRICKS_RUN}"
    winetricks -q ${GNP_WINETRICKS_RUN} || echo "⚠️ Winetricks a retourné une erreur, on continue quand même."
fi
touch "$WINEPREFIX/.gnp_wine_ready"
echo "✅ Wineprefix prêt."
