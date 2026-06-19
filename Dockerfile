FROM debian:12
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 &&     apt-get update &&     apt-get install -y --no-install-recommends         ca-certificates curl wget tar xz-utils unzip jq procps gosu locales tzdata python3         xvfb cabextract winbind p7zip-full         wine wine32 wine64         lib32gcc-s1 lib32stdc++6 libstdc++6:i386 libgcc-s1:i386 &&     rm -rf /var/lib/apt/lists/*
RUN curl -L --fail -o /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x /usr/local/bin/winetricks
RUN mkdir -p /opt/steam /opt/games/server /opt/games/config /opt/games/saves /opt/games/backups /opt/wine &&     groupadd -g 1000 gnp && useradd -m -u 1000 -g 1000 -s /bin/bash gnp &&     chown -R gnp:gnp /opt/steam /opt/games /opt/wine /home/gnp
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh
ENV GNP_TZ=Europe/Paris GNP_PUID=1000 GNP_PGID=1000
ENV GNP_STEAM_APP_ID=2465200 GNP_STEAM_USER=anonymous GNP_STEAM_PASSWORD= GNP_STEAM_AUTH= GNP_STEAM_BETA= GNP_STEAM_BETA_PASSWORD= GNP_GAME_UPDATE=true GNP_FORCE_PLATFORM_WINDOWS=true
ENV WINEPREFIX=/opt/wine WINEDEBUG=-all WINEDLLOVERRIDES=mscoree,mshtml= GNP_WINETRICKS_RUN="vcrun2022 corefonts sound=disabled" DISPLAY=:99
ENV GNP_SERVER_NAME=GNP_SOTF_Server GNP_SERVER_PASSWORD= GNP_IP_ADDRESS=0.0.0.0 GNP_GAME_PORT=8766 GNP_QUERY_PORT=27016 GNP_BLOB_SYNC_PORT=9700 GNP_MAX_PLAYERS=8 GNP_LAN_ONLY=false
ENV GNP_SAVE_SLOT=1 GNP_SAVE_MODE=Continue GNP_GAME_MODE=Normal GNP_SAVE_INTERVAL=600 GNP_IDLE_DAY_CYCLE_SPEED=0.0 GNP_IDLE_TARGET_FRAMERATE=5 GNP_ACTIVE_TARGET_FRAMERATE=60
ENV GNP_LOG_FILES_ENABLED=true GNP_TIMESTAMP_LOG_FILENAMES=true GNP_TIMESTAMP_LOG_ENTRIES=true GNP_SKIP_NETWORK_ACCESSIBILITY_TEST=true GNP_OWNER_STEAM_IDS= GNP_VERBOSE_LOGGING=false GNP_FILTER_WINE_LOGS=true GNP_EXTRA_ARGS=
WORKDIR /opt/games/server
EXPOSE 8766/udp
EXPOSE 27016/udp
EXPOSE 9700/udp

HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 CMD /scripts/healthcheck.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
