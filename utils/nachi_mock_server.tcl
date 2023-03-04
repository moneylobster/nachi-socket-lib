proc echserv {port} {
	upvar ss s
	set s [socket -server EchoAccept $port]
	vwait forever
}

proc EchoAccept {sock addr port} {
	global echo
	
	puts "Accept $sock from $addr port $port"
	set echo(addr,$sock) [list $addr $port]
	
	fconfigure $sock -buffering none -encoding binary -blocking 0 -translation binary
	
	fileevent $sock readable [list Echoalt $sock]
}

proc Echoalt {sock} {
	global echo
	
	set line [read $sock 4]
	flush $sock
	
	if {[eof $sock]} {
		close $sock
		puts "Close $echo(addr,$sock)"
		unset echo(addr,$sock)
	} else {
		if {[string length $line]>0} {
			binary scan $line R* res
			puts "input: $res"
		}
	}
}

proc sncont {sock} {
	upvar a1 a1
	upvar a2 a2
	upvar a3 a3
	upvar a4 a4
	upvar a5 a5
	upvar a6 a6
	puts -nonewline $sock [binary format R* $a1]
	puts -nonewline $sock [binary format R* $a2]
	puts -nonewline $sock [binary format R* $a3]
	puts -nonewline $sock [binary format R* $a4]
	puts -nonewline $sock [binary format R* $a5]
	puts -nonewline $sock [binary format R* $a6]
	after 2 "sncont $sock"
}

proc sn {sock msg} {
	set msg [binary format R* $msg]
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
	puts -nonewline $sock $msg
}

foreach a {a1 a2 a3 a4 a5 a6} {
	set $a 1
}

console show
echserv 10300