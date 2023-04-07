#!/bin/bash

set -e

function createDirectories() {
  local fileTypes=("pem" "key" "crt")
  for fileType in "${fileTypes[@]}"; do
    local dirPath="${EGG_PATH_TLS}/${fileType}"
    if [[ ! -d "$dirPath" ]]; then
      mkdir -p "$dirPath"
    fi
  done
}

function shouldExit() {
  [[ "$EGG_CONF_GENERATE" -eq 0 ]] || [[ "$EGG_TLS_GENERATE" -eq 0 ]]
}

function updateConfig() {
  sed -i "s@^#set ssl-privatekey "eggdrop.key"@set ssl-privatekey "${EGG_PATH_TLS}/key/${EGG_LONG_NAME}.key"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
  sed -i "s@^#set ssl-certificate "eggdrop.crt"@set ssl-certificate "${EGG_PATH_TLS}/crt/${EGG_LONG_NAME}.crt"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
}

function removeIfExistsAndRegenerate() {
  local fileType="$1"
  local filePath="${EGG_PATH_TLS}/${fileType}/${EGG_LONG_NAME}.${fileType}"
  if [[ ! -f "$filePath" ]] || [[ "$EGG_TLS_REGENERATE" -eq 1 ]]; then
    rm -f "$filePath"
    return 0
  fi
  return 1
}

function generatePem() {
  if removeIfExistsAndRegenerate "pem"; then
    openssl ecparam -genkey -name prime256v1 -out "${EGG_PATH_TLS}/pem/${EGG_LONG_NAME}.pem"
  fi
}

function generateKey() {
  if removeIfExistsAndRegenerate "key"; then
    openssl genrsa -out "${EGG_PATH_TLS}/key/${EGG_LONG_NAME}.key" 4096
  fi
}

function generateCertificate() {
  if removeIfExistsAndRegenerate "crt"; then
    openssl req -new -key "${EGG_PATH_TLS}/key/${EGG_LONG_NAME}.key" -x509 -out "${EGG_PATH_TLS}/crt/${EGG_LONG_NAME}.crt" -days 365 -batch
  fi
}

if shouldExit; then
  exit 0
fi

createDirectories
updateConfig
generatePem
generateKey
generateCertificate