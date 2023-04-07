#!/bin/bash
[ "$EGG_CAPS" = 0 ] && exit 0

sed -i "s@^#set invite-notify 0@set invite-notify 1@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^#set message-tags 0@set message-tags 1@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^#set account-tag 0@set account-tag 1@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
