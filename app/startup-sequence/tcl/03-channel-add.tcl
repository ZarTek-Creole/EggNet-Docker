namespace eval Eggdrop {
  proc add_channels {} {
    set irc_channels $::env(IRC_CHANNELS)
    set channels [channels]
    
    putlog "Adding channels to Bot $irc_channels"
    putlog "Channels in Bot $channels"

    foreach channel [split $irc_channels ","] {
      putlog "Adding channel $channel to Bot"
      
      if { [lsearch $channels $channel] == -1 } {
        channel add $channel {
          idle-kick       0
          stopnethack-mode   0
          flood-chan       0:0
          aop-delay       0:0
        }
      }
    }
    
    set channels [channels]
    putlog "Channels after in Bot $channels"
  }
}

Eggdrop::add_channels