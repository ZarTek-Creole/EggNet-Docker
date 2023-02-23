# 
proc bgerror { message } {
	set timestamp	[clock format [clock seconds]]
	set filePipe	[open ${::EGG_PATH_LOGS}/${::EGG_LONG_NAME}_error.log {WRONLY CREAT APPEND}]
	set lastProc	[info level 0]
	puts ${filePipe} "${timestamp}: bgerror in ${lastProc} '${message}'";
	foreach err [split ${::errorInfo} "\n"] {
		puts ${filePipe} ${err}
		putallbots "NET_ERROR ${::EGG_LONG_NAME} ${err}"
	}
	close ${filePipe}
}