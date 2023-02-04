foreach Channel [split ${::env(IRC_CHANNELS)} ,] {
	if { [lsearch [channels] ${Channel}] == "-1" } {
		channel add ${Channel} {
			idle-kick 			0
			stopnethack-mode 	0
			flood-chan 			0:0
			aop-delay 			0:0
		}
	}
}