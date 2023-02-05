# Bind the event "userfile-loaded" to the proc "userfileloaded"
bind evnt - userfile-loaded userfileloaded

# Define the proc "userfileloaded" to handle the "userfile-loaded" event
proc userfileloaded { args } {
	# Check if the user is valid
	if { [validuser ${::env(PPL_USER)}] != 1 } {
		try {
			# If not, add the user and set their password
			adduser ${::env(PPL_USER)}
			setuser ${::env(PPL_USER)} PASS ${::env(PPL_PASS)}
			# Set attributes for the user
			chattr ${::env(PPL_USER)} +hjlmnoptx
			# Save the user data
			save
		} on error {} {
			# Handle any errors that may occur
    		putlog "Error userfileloaded: ${error}"
		} finally {
			putlog "Ajout du user ${::env(PPL_USER)}"
		}
	}
	# Call the "BOTNET_CREATE" proc
	::BOTNET_CREATE
}

# Call the "BOTNET_CREATE" proc every 300 seconds
# ::cron::every Update_botnet 300 ::BOTNET_CREATE

proc ::BOTNET_CREATE {} {
	foreach FILE_SCT [glob -directory ${::EGG_PATH_SECRETS} *.sct] {
    set B_NAME [file rootname [file tail ${FILE_SCT}]]
    if { "${::botnet-nick}" == "${B_NAME}" } { continue }
	set FILE_SCT		[open "${FILE_SCT}" r]
    set SCT_DATA 		[split [read ${FILE_SCT}]]
    close ${FILE_SCT}
    set BOT_ISMASTER	[lindex ${SCT_DATA} 0]
    set BOT_PASSWORD	[lindex ${SCT_DATA} 1]
    set BOT_PORT		[lindex ${SCT_DATA} 2]
    set BOT_HOSTNAME	[lindex ${SCT_DATA} 3]
    set BOT_LASTMOD		[lindex ${SCT_DATA} 4]
	putlog "debug : ${SCT_DATA}"
	putlog "debug : BOT_PASSWORD ${BOT_PASSWORD} BOT_PORT ${BOT_PORT} BOT_HOSTNAME ${BOT_HOSTNAME}"

    if {$BOT_ISMASTER == 1 && $::EGG_ISMASTER == 0} {
      	putlog "Ajout HUB addbot ${B_NAME} ${BOT_HOSTNAME} ${BOT_PORT}"
      	deluser ${B_NAME}
      	addbot ${B_NAME} ${BOT_HOSTNAME} ${BOT_PORT}
      	botattr ${B_NAME} +h
      	setuser ${B_NAME} XTRA EGG_LASTMOD ${BOT_LASTMOD}
    } elseif {$BOT_ISMASTER == 0 && $::EGG_ISMASTER == 1} {
      	putlog "Ajout LEAF addbot ${B_NAME} ${BOT_HOSTNAME}"
      	deluser ${B_NAME}
      	addbot ${B_NAME} ${BOT_HOSTNAME}
      	botattr ${B_NAME} +l
      	setuser ${B_NAME} XTRA EGG_LASTMOD ${BOT_LASTMOD}
    } elseif {[validuser ${B_NAME}] == 1 && ${BOT_LASTMOD} != [getuser ${B_NAME} XTRA EGG_LASTMOD]} {
		putlog "Changement mot de passe ${B_NAME}"
      	setuser ${B_NAME} PASS ${BOT_PASSWORD}
    }

    catch {link ${B_NAME}}
  }
      catch {save}
}
# Call the "BOTNET_CREATE" proc after 5 seconds
timer 5 ::BOTNET_CREATE 0