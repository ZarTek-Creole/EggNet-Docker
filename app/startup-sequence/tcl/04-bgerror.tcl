proc bgerror {message} {
  putlog "Error in errorHandling::bgerror: $errMsg"
  ::errorHandling::bgerror $message
}
namespace eval ::errorHandling {
    variable eggPathLogs
    variable eggLongName
}

proc ::errorHandling::bgerror {message} {
    try {
        set timestamp [clock format [clock seconds]]
        set logFile [::errorHandling::getLogFile]
        set lastProc [info level 0]

        ::errorHandling::putLogInFile $logFile $timestamp $lastProc $message
        ::errorHandling::sendErrorToAllBots $message
    } on error {errMsg options} {
        puts "Error in errorHandling::bgerror: $errMsg"
    }
}

proc ::errorHandling::getLogFile {} {
    set logFileName "${::errorHandling::eggLongName}_error.log"
    return [file join ${::errorHandling::eggPathLogs} $logFileName]
}

proc ::errorHandling::putLogInFile {logFile timestamp lastProc message} {
    set filePipe [open $logFile {WRONLY CREAT APPEND}]
    puts $filePipe "${timestamp}: bgerror in ${lastProc} '${message}'"

    if {[info exists errorInfo]} {
        foreach err [split $errorInfo "\n"] {
            puts $filePipe $err
        }
    }

    close $filePipe
}

proc ::errorHandling::sendErrorToAllBots {message} {
    if {[info exists errorInfo]} {
        foreach err [split $errorInfo "\n"] {
            putallbots "NET_ERROR ${::errorHandling::eggLongName} $err"
        }
    }
}
