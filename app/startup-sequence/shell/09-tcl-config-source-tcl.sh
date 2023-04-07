#!/bin/bash
# shellcheck disable=SC2028
# Need generate or stop ?
[ "$EGG_CONF_GENERATE" == 0 ] && exit 0

echo "proc LoadDirectoryFiles { Directory {Extention *.tcl} {Load_Name \"\"} } {
  foreach FILE_SCRIPT [lsort [glob -nocomplain -directory \${Directory}/ \${Extention}]] {
    if { [file readable \${FILE_SCRIPT}] } {
      putlog \"\${Load_Name} script sourced: \${FILE_SCRIPT}\";
      if { [catch {source \${FILE_SCRIPT}} error] } {
        foreach { errorline } [split \$::errorInfo \"\\n\"] {
          putlog \${errorline};
        };
        die \"Error in '\${FILE_SCRIPT}' file. Return:\$error\";
      }
    } else {
      putlog \"Le fichier '\${FILE_SCRIPT}' ne peut pas être lus\";
    }
  }
}" >> "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

# script docker
echo "LoadDirectoryFiles /startup-sequence/tcl *.tcl Docker" >>"${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

# script global
echo "LoadDirectoryFiles ${EGG_PATH_SCRIPTS} *.tcl Global" >>"${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

# scripts Network
echo "LoadDirectoryFiles ${EGG_PATH_SCRIPTS}/${IRC_NETNAME} *.tcl Network" >>"${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

# scripts user
echo "LoadDirectoryFiles ${EGG_PATH_SCRIPTS}/${IRC_NETNAME}/${EGG_NICK} *.tcl User" >>"${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
