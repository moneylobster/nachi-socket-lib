# How to configure the robot

## Sending programs to the robot via FTP
* Connect to the robot via FTP.
	* IP: mDNS works, NRA2011.local
	* port: 21
	* no encryption
	* username: anonymous
* Send the usertask and the robot program to /PROGRAM.
* Close FTP.

## Compiling the programs on the robot
* Open Monitor2 > 37 Usertask Monitor
	* Turn off any programs that are already running.
* Service Utilities > 9 Program Conversion > 8 Language
* Press right until you get to the upper file selection screen
* Press OK on the program you want to compile, then ensuring the cursor is still on the same program (if the blue selection moved down a row, press up), press OK again.
* Press Execute to compile.
