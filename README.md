# VERSION ALPHA !!! NE PAS UTILISER EN PRODUCTION SANS TEST

# 🌲 Sons Of The Forest Dedicated Server - GNP Standard

## 📌 Description

Image Docker dédiée au serveur **Sons Of The Forest**, standardisée pour l’écosystème **GameNodePanel (GNP)**.

Le serveur dédié officiel de Sons Of The Forest est distribué via SteamCMD avec l’AppID `2465200`. Le dépôt officiel est Windows, donc cette image utilise **Wine + Xvfb** pour l’exécuter dans un conteneur Linux.

---

## 🚀 Features

- Installation / mise à jour via SteamCMD
- AppID serveur dédié : `2465200`
- Forçage du dépôt Windows SteamCMD
- Exécution via Wine + Xvfb
- Génération automatique du fichier `dedicatedserver.cfg`
- Génération automatique du fichier `ownerswhitelist.txt`
- Variables GNP unifiées (`GNP_*`)
- Volumes persistants pour SteamCMD, fichiers serveur, configuration, saves, backups et Wine
- Logs filtrés pour éviter le spam Wine / shaders Unity
- Compatible avec l’approche Docker de GameNodePanel

---

## ⚠️ Points importants Sons Of The Forest

Le dédié Sons Of The Forest utilise un dossier utilisateur persistant. Dans cette image, il est forcé avec :

```bash
-userdatapath "Z:/opt/games/config"
```

Le dossier `/opt/games/config` contient donc :

```txt
dedicatedserver.cfg
ownerswhitelist.txt
Saves/
logs éventuels
```

Ports officiels par défaut :

```txt
8766/udp  -> GamePort
27016/udp -> QueryPort
9700/udp  -> BlobSyncPort
```

⚠️ `GNP_SKIP_NETWORK_ACCESSIBILITY_TEST=true` est activé par défaut, car le test réseau du serveur dédié peut poser problème en Docker/NAT même si les ports sont bien exposés.

---

## 📁 Structure GNP

```txt
/opt/steam             -> SteamCMD
/opt/games/server      -> Fichiers serveur Sons Of The Forest
/opt/games/config      -> dedicatedserver.cfg, ownerswhitelist.txt, saves, logs
/opt/games/saves       -> Dossier réservé GNP pour exports/backups
/opt/games/backups     -> Backups éventuels côté GNP
/opt/wine              -> Wineprefix persistant
```

---

## ⚙️ Variables d’environnement GNP

```env
GNP_STEAM_APP_ID=2465200
GNP_SERVER_NAME=GNP_SOTF_Server
GNP_SERVER_PASSWORD=
GNP_IP_ADDRESS=0.0.0.0
GNP_GAME_PORT=8766
GNP_QUERY_PORT=27016
GNP_BLOB_SYNC_PORT=9700
GNP_MAX_PLAYERS=8
GNP_LAN_ONLY=false
GNP_SAVE_SLOT=1
GNP_SAVE_MODE=Continue
GNP_GAME_MODE=Normal
GNP_SAVE_INTERVAL=600
GNP_OWNER_STEAM_IDS=
```

`GNP_MAX_PLAYERS` doit rester entre `1` et `8`.

Valeurs courantes pour `GNP_GAME_MODE` : `Normal`, `Hard`, `HardSurvival`, `Peaceful`, `Creative`, `Custom`.

⚠️ Attention avec `GNP_SAVE_MODE=New` : le serveur peut recréer/écraser la sauvegarde selon le comportement du jeu. Pour GNP, `Continue` est recommandé.

---

## 🧪 Build local

```bash
docker build -t slymer29/gnp-sons-of-the-forest:latest .
```

## ▶️ Lancement avec Docker Compose

```bash
docker compose up -d
```

```bash
docker logs -f gnp-sons-of-the-forest
```

## 📤 Push Docker Hub

```bash
docker login
docker build -t slymer29/gnp-sons-of-the-forest:latest .
docker push slymer29/gnp-sons-of-the-forest:latest
```

Tag versionné :

```bash
docker tag slymer29/gnp-sons-of-the-forest:latest slymer29/gnp-sons-of-the-forest:0.1.0-alpha
docker push slymer29/gnp-sons-of-the-forest:0.1.0-alpha
```

---

## 🧩 Exemple d’intégration GNP

```env
game_runtime_type=docker
docker_image=slymer29/gnp-sons-of-the-forest:latest
default_port=8766
query_port=27016
blob_sync_port=9700
max_players=8
```

---

## ✅ Résumé technique

```txt
Jeu        : Sons Of The Forest
Serveur    : Dedicated Server officiel Steam
AppID      : 2465200
OS serveur : Windows uniquement côté dépôt officiel
Runtime    : Wine + Xvfb
Port jeu   : 8766/udp
Query      : 27016/udp
BlobSync   : 9700/udp
Config     : /opt/games/config/dedicatedserver.cfg
Owners     : /opt/games/config/ownerswhitelist.txt
```
