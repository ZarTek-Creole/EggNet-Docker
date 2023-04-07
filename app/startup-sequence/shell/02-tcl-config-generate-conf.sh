#!/bin/bash

# Single Responsibility Principle functions

generateSecretFile() {
  echo "${EGG_ISMASTER} ${EGG_PASSWORD} ${EGG_LISTEN_BOTS:-+5555} ${EGG_HOSTNAME} ${EGG_LASTMOD}" > "${EGG_PATH_SECRETS}/${EGG_LONG_NAME}.sct"
}

createDirectories() {
  mkdir -p "${EGG_PATH_DATA}" "${EGG_PATH_LOGS}" "${EGG_PATH_CONF}" "${EGG_PATH_SCRIPTS}/${IRC_NETNAME}/${EGG_NICK}" "${EGG_PATH_SECRETS}"
  mkdir -p "${EGG_PATH_TLS}" "${EGG_PATH_TLS}/key" "${EGG_PATH_TLS}/crt" "${EGG_PATH_TLS}/pem"
}

copyConfigurationTemplate() {
  cp "${INSTALLDIR}/eggdrop.conf.dist" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf" || exit 1
}

createSymlink() {
  ln -sfn "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf" "${INSTALLDIR}/eggdrop.conf" || exit 1
}

editConfiguration() {
  local configFile="${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
  
  # Server setting
  sed -i -e "s@^server add@# server add@" "${configFile}"
  sed -i -e "s@# server add ssl.example.net +7000@server add ${IRC_SERVER:-"irc.libera.chat"} ${IRC_PORT:-"+6697"} ${IRC_PASSWORD:-}@g" "${configFile}"
  
  # Eggdrop name
  sed -i -e "s@set nick \"Lamestbot\"@set nick \"${EGG_NICK:-"Docker-Egg-???"}\"@" "${configFile}"
  
  # Listen
  sed -i -e "s@#listen 3333 all@listen ${EGG_LISTEN_ALL:-"3333"} all@" "${configFile}"
  sed -i -e "s@#   listen +5555 all@listen ${EGG_LISTEN_BOTS:-"+5555"} bots@" "${configFile}"
  
  
  # DNS servers
  sed -i -e "s@^#set dns-servers@set dns-servers@" "${configFile}"
  
  # Support user modes @&~
  sed -i -e '/^set opchars "@"/d' "${configFile}"
  sed -i -e 's@^#set opchars@set opchars@' "${configFile}"
  
  # ident
  sed -i -e "s@^set username \"lamest\"@set username \"${EGG_USERNAME:-${IRC_NETNAME}}\"@" "${configFile}"
  sed -i -e "s@^#set pidfile \"pid.LamestBot\"@set pidfile \"${INSTALLDIR}/bot.pid\"@" "${configFile}"
  
  # no chanmode enforce
  sed -i -e "s@set default-chanmode \"nt\"@set default-chanmode \"\"@" "${configFile}"
  
  # nick on botnet
  sed -i -e "s@^#set botnet-nick \"LlamaBot\"@set botnet-nick \"${EGG_LONG_NAME}\"@" "${configFile}"
  
  
  # This setting makes the bot try to get his original nickname back if its primary nickname is already in use.
  sed -i -e "s@set keep-nick 1@set keep-nick ${EGG_KEEP_NICK}@" "${configFile}"
  
  sed -i -e "s@#set owner \"MrLame, MrsLame\"@set owner \"${EGG_OWNER}\"@" "${configFile}"
}
# Files names
sed -i -e "s@set userfile \"LamestBot.user\"@set userfile \"${EGG_PATH_DATA}/${EGG_NICK}.user\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i -e "s@set chanfile \"LamestBot.chan\"@set chanfile \"${EGG_PATH_DATA}/${EGG_NICK}.chan\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i -e "s@set notefile \"LamestBot.notes\"@set notefile \"${EGG_PATH_DATA}/${EGG_NICK}.notes\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

sed -i -e "s@set realname \"/msg LamestBot hello\"@set realname \"Docker Eggdrop! Visit: https://t.ly/MbtS\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i -e "s@set network \"I.didn't.edit.my.config.file.net\"@set network \"${IRC_NETNAME:-Default}\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i -e '/edit your config file completely like you were told/d' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i -e '/Please make sure you edit your config file completely/d' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

# BOTNET SETTINGS
echo "### BOTNET SETTINGS ###" >> "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
echo "set EGG_ISMASTER \"${EGG_ISMASTER:-0}\"" >> "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

if [ ! -f "${INSTALLDIR}/eggdrop.sct" ]; then
  EGG_PASSWORD=$(date +%s | sha256sum | base64 | head -c 16)
else
  EGG_PASSWORD=$(cat "${INSTALLDIR}/eggdrop.sct")
fi

EGG_LASTMOD=$(date +%s)
echo "set ::EGG_LASTMOD        \"${EGG_LASTMOD}\""          >> "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

echo "set ::EGG_PASSWORD            \"${EGG_PASSWORD:-BOTNET}\""    >> "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
if [[ ! -f "${EGG_PATH_SECRETS}/${EGG_LONG_NAME}.sct" ]]; then
  touch "${EGG_PATH_SECRETS}/${EGG_LONG_NAME}.sct"
fi
# Generate the secret file
echo "${EGG_ISMASTER} ${EGG_PASSWORD} ${EGG_LISTEN_BOTS:-+5555} ${EGG_HOSTNAME} ${EGG_LASTMOD}" > "${EGG_PATH_SECRETS}/${EGG_LONG_NAME}.sct"

# BOTNET SETTINGS - END
sed -i "s@^set msg-rate 2@set msg-rate 0@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^set telnet-flood 5:60@set telnet-flood 0:0@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^set max-queue-msg 300@set max-queue-msg 600@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

# Remove flood
sed -i 's@15:60@0:0@g' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i 's@3:10@0:0@g' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i 's@5:60@0:0@g' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

