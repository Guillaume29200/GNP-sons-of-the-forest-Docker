#!/bin/bash
set -e
CONFIG_DIR="/opt/games/config"
CFG_FILE="${CONFIG_DIR}/dedicatedserver.cfg"
OWNERS_FILE="${CONFIG_DIR}/ownerswhitelist.txt"
mkdir -p "$CONFIG_DIR" /opt/games/saves
python3 - <<'PYJSON'
import json, os
cfg = {
    "IpAddress": os.getenv("GNP_IP_ADDRESS", "0.0.0.0"),
    "GamePort": int(os.getenv("GNP_GAME_PORT", "8766")),
    "QueryPort": int(os.getenv("GNP_QUERY_PORT", "27016")),
    "BlobSyncPort": int(os.getenv("GNP_BLOB_SYNC_PORT", "9700")),
    "ServerName": os.getenv("GNP_SERVER_NAME", "GNP_SOTF_Server"),
    "MaxPlayers": int(os.getenv("GNP_MAX_PLAYERS", "8")),
    "Password": os.getenv("GNP_SERVER_PASSWORD", ""),
    "LanOnly": os.getenv("GNP_LAN_ONLY", "false").lower() == "true",
    "SaveSlot": int(os.getenv("GNP_SAVE_SLOT", "1")),
    "SaveMode": os.getenv("GNP_SAVE_MODE", "Continue"),
    "GameMode": os.getenv("GNP_GAME_MODE", "Normal"),
    "SaveInterval": int(os.getenv("GNP_SAVE_INTERVAL", "600")),
    "IdleDayCycleSpeed": float(os.getenv("GNP_IDLE_DAY_CYCLE_SPEED", "0.0")),
    "IdleTargetFramerate": int(os.getenv("GNP_IDLE_TARGET_FRAMERATE", "5")),
    "ActiveTargetFramerate": int(os.getenv("GNP_ACTIVE_TARGET_FRAMERATE", "60")),
    "LogFilesEnabled": os.getenv("GNP_LOG_FILES_ENABLED", "true").lower() == "true",
    "TimestampLogFilenames": os.getenv("GNP_TIMESTAMP_LOG_FILENAMES", "true").lower() == "true",
    "TimestampLogEntries": os.getenv("GNP_TIMESTAMP_LOG_ENTRIES", "true").lower() == "true",
    "SkipNetworkAccessibilityTest": os.getenv("GNP_SKIP_NETWORK_ACCESSIBILITY_TEST", "true").lower() == "true",
    "GameSettings": {},
    "CustomGameModeSettings": {}
}
with open("/opt/games/config/dedicatedserver.cfg", "w", encoding="utf-8") as f:
    json.dump(cfg, f, indent=4, ensure_ascii=False)
PYJSON
: > "$OWNERS_FILE"
if [ -n "${GNP_OWNER_STEAM_IDS:-}" ]; then
    for owner in ${GNP_OWNER_STEAM_IDS}; do echo "$owner" >> "$OWNERS_FILE"; done
else
    printf '%s
' '# Ajoute ici les SteamID64 des propriétaires/admins du serveur.' '# Un SteamID64 par ligne.' > "$OWNERS_FILE"
fi
echo "✅ Configuration générée : ${CFG_FILE}"
echo "✅ Owners whitelist : ${OWNERS_FILE}"
