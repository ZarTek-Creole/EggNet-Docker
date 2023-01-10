proc bgerror { message } {
	set timestamp	[clock format [clock seconds]]
	set FILE_PIPE	[open ${::EGG_PATH_LOGS}/${::EGG_LONG_NAME}_error.log {WRONLY CREAT APPEND}]
	set LASTPROC	[info level 0]
	puts $FILE_PIPE "$timestamp: bgerror in $LASTPROC '$message'"
	foreach err [split $::errorInfo "\n"] {
		puts $FILE_PIPE $err
	}
	close $FILE_PIPE
}