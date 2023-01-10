bind evnt - userfile-loaded userfileloaded
proc userfileloaded { args } {
	if { [validuser ${::env(PPL_USER)}] != 1 } {
		adduser ${::env(PPL_USER)}
		setuser ${::env(PPL_USER)} PASS ${::env(PPL_PASS)}
		chattr ${::env(PPL_USER)} +hjlmnoptx
		catch {save}
	}
	::BOTNET_CREATE
}
#::cron::every Update_botnet 300 ::BOTNET_CREATE
timer 5 ::BOTNET_CREATE 0
proc ::BOTNET_CREATE {} {
	foreach FILE_SCT [glob -directory $::EGG_PATH_SECRETS *.sct] {
		set B_NAME		[file rootname [file tail $FILE_SCT]]
		if { "${::botnet-nick}" == "$B_NAME" } { continue }

		set FILE_PIPE	[open "$FILE_SCT" r];
		set SCT_DATA	[read $FILE_PIPE];
		close $FILE_PIPE;
		
		set BOT_ISMASTER	[lindex $SCT_DATA 0];
		set BOT_PASSWORD	[lindex $SCT_DATA 1];
		set BOT_PORT		[lindex $SCT_DATA 2];
		set BOT_HOSTNAME	[lindex $SCT_DATA 3];
		set BOT_LASTMOD		[lindex $SCT_DATA 4];
		if { [validuser ${B_NAME}] != 1 && $BOT_ISMASTER == 1 && $::EGG_ISMASTER == 0} {
			putlog "ajout HUB addbot ${B_NAME} ${BOT_HOSTNAME} ${BOT_PORT}"
			deluser ${B_NAME}
			addbot ${B_NAME} ${BOT_HOSTNAME} ${BOT_PORT}
			botattr ${B_NAME} +h
			setuser ${B_NAME} XTRA EGG_LASTMOD ${BOT_LASTMOD}
			catch {save}
			catch {link ${B_NAME}}
		}
		if { [validuser ${B_NAME}] != 1 && $BOT_ISMASTER == 0 && $::EGG_ISMASTER == 1} {
			putlog "Ajout LEAF addbot ${B_NAME} ${BOT_HOSTNAME} ${BOT_PORT}"
			deluser ${B_NAME}
			addbot ${B_NAME} ${BOT_HOSTNAME}
			botattr	${B_NAME} +l
			setuser ${B_NAME} XTRA EGG_LASTMOD ${BOT_LASTMOD}
			catch {save}
		}
		if { [validuser ${B_NAME}] == 1 && ${BOT_LASTMOD} != [getuser ${B_NAME} XTRA EGG_LASTMOD]} {
			putlog "setuser ${B_NAME} PASS ${BOT_PASSWORD}"
			setuser ${B_NAME} PASS ${BOT_PASSWORD}
			catch {save}
		}
	}
}
