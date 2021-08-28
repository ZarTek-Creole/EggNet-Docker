#!/bin/bash
if [ "$(id -u)" = '0' ]; then
	echo "$(/sbin/ip route|awk '/default/ { print $3 }') hote" >> /etc/hosts
fi