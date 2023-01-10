#!/bin/bash
# Need generate or stop ?
[ $EGG_CONF_GENERATE == 0 ] && exit 0
# script docker
echo "foreach FILE_SCRIPT [lsort [glob -nocomplain -directory /startup-sequence/tcl/ *.tcl]]  { if { [file readable \$FILE_SCRIPT] } { putlog \"Docker script sourced: \${FILE_SCRIPT}\"; if [catch {source \${FILE_SCRIPT}} error] { die \"Error in '\${FILE_SCRIPT}' file. Return:\$error\" } } }" >> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf

# script global
echo "foreach FILE_SCRIPT [glob -nocomplain -directory ${EGG_PATH_SCRIPTS}/ *.tcl]  { if { [file readable \$FILE_SCRIPT] } { putlog \"Global script sourced: \${FILE_SCRIPT}\"; if [catch {source \${FILE_SCRIPT}} error] { die \"Error in '\${FILE_SCRIPT}' file. Return:\$error\" } } }" >> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf

# scripts Network
echo "foreach FILE_SCRIPT [glob -nocomplain -directory ${EGG_PATH_SCRIPTS}/${IRC_NETNAME}/ *.tcl]  { if { [file readable \$FILE_SCRIPT] } { putlog \"Network script sourced: \${FILE_SCRIPT}\"; if [catch {source \${FILE_SCRIPT}} error] { die \"Error in '\${FILE_SCRIPT}' file. Return:\$error\" } } }" >> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf

# scripts user
echo "foreach FILE_SCRIPT [glob -nocomplain -directory ${EGG_PATH_SCRIPTS}/${IRC_NETNAME}/${EGG_NICK}/ *.tcl]  { if { [file readable \$FILE_SCRIPT] } { putlog \"user script sourced: \${FILE_SCRIPT}\"; if [catch {source \${FILE_SCRIPT}} error] { die \"Error in '\${FILE_SCRIPT}' file. Return:\$error\" } } }" >> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf