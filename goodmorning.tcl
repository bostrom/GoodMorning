################################################
#################### ABOUT #####################
################################################
#
# Goodmorning-0.1 by Fredrik Bostrom
# for Eggdrop IRC bot
#
# Usage:
#  - edit the time the script is supposed to 
#    run each day (e.g. 09:00)
#  - load script in eggdrop
#
################################################
################ CONFIGURATION #################
################################################

set fireAtTime "tomorrow 08:00"

################################################
######## DON'T EDIT BEOYND THIS LINE! ##########
################################################

# utility sleep timer
set endSleep 0
proc sleep {time} {
    global endSleep
    after $time set endSleep 1
    vwait endSleep
    unset endSleep
}

# the run-at-time procedure
proc at {time args} {
    if {[llength $args]==1} {
	set args [lindex $args 0]
    }
    set dt [expr {($time - [clock seconds])*1000}]
    return [after $dt $args]
}

# procedure to do the goodmorning stuff
proc goodMorning {{test "false"}} {
    if {!$test} {
	# set the new timer to fire
	setTimer
    }

#    putserv "PRIVMSG \#leiftest :Morning 1"
#    putserv "PRIVMSG \#kaverin :========== FORTUNE ==========="
#    putserv "PRIVMSG \#kaverin :Plomeros: !fortune"
    after 5000 goodMorning3
}

proc goodMorning2 {} {
#    putserv "PRIVMSG \#leiftest :Morning 2"
#    putserv "PRIVMSG \#kaverin :======== TODAY'S MENU ========"
#    putserv "PRIVMSG \#kaverin :Plomeros: !unicafe viikuna"
#    after 5000 goodMorning3
}

proc goodMorning3 {} {
#    putserv "PRIVMSG \#leiftest :Morning 3"
    putserv "PRIVMSG \#kaverin :======== TODAY'S WORD ========"
    if { [catch {pub:wordoftheday "" "" "" \#kaverin ""} fid] } {
	putserv "PRIVMSG \#kaverin :WotD failed!"
    }
    
    after 5000 goodMorning4
}

proc goodMorning4 {} {
#    putserv "PRIVMSG \#leiftest :Morning 3"
    putserv "PRIVMSG \#kaverin :====== TODAY'S WEATHER ======="
    pub:fmi "" "" "" \#kaverin ""
    after 5000 goodMorning5
}

proc setTimer {} {
    global fireAtTime

    # parse the time 
    set time [clock scan $fireAtTime]
    
    # set the timer
    set timer [at $time goodMorning]
    
    set timeString [clock format $time -format "%Y-%m-%d %H:%M"]
    
    putserv "NOTICE fredde :Good Morning with id $timer will run at $timeString."
}

# better to start it manually (uncomment to start automatically)
#setTimer

################################################
putlog "Good Morning script loaded"
################################################
