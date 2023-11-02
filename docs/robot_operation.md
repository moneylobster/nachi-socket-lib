# Robot Arm Setup
These instructions are meant for the Nachi MZ07 arm in our lab, so some details may differ for other robots.

## Turning the arm on
* Connect the black cable in the cabinet to the force sensor. The white arrows on both connectors should match.
* Connect the white ethernet cable to the controlling computer.
* Turn on both boxes in the cabinet.

## Calibration and connecting to the computer
* Get the teaching pendant and sign in as an advanced user:
	* Press the R button.
	* Type in 314 to get the "Change the protecting level" option and press enter.
	* Type in 12345 as the password.
* At this point, you may want to calibrate the force-torque sensor readings if you are going to be using them
	* See [this document](force_calibration.md) for instructions.
### Connecting to the computer
> [!IMPORTANT]
> Linux users may need to do additional configuration when connecting.
> Try setting the IP and netmask for the wired connection manually and assign the robot a static IP from the TCP/IP menu described below.

* Now view the IP assigned to the robot arm:
	* Press the "Constant Setting" button.
	* Select "8 Communication", then "2 Ethernet", then "1 TCP/IP"
	* Note down the IP address of the robot. The computer-side client needs this to connect.
	> [!IMPORTANT]
	> If the IP address shows up as 0.0.0.0 in Windows, restart Windows' DHCP server: Go to network settings on the computer and set the IP assignment to manual-IPv4, then back to automatic.
	* Press R until you get back to the main screen.
	
> [!NOTE]
> You can also use the mDNS address instead of the IP: `NRA2011.local`.
> This may not work if your computer doesn't support mDNS.

## Running the robot programs
* Ensure that the robot program is the correct one:
	* On the top of the teach pendant screen, the "program" field should read 100.
	* If not, change the program:
		* Press "ENABLE"+"PROG" (ENABLE is in top left and PROG is above the arrows) and type in 100 as the designated program.
* Change the robot's operation mode from teach to playback:
	* We do this to execute the robot program continuously without human involvement
	* Keep the teach pendant next to you, and press the E-STOP button (top right, red) if the robot needs to be stopped from this point onwards.
	* Change the dial on the teach pendant (top left) to the playback option (icon looks like a recycling sign)
	* Turn the key on the box in the cabinet (underneath the E-STOP button) to the playback option (icon looks like a flower)
### Running the background task
* Open the usertask menu
	* Press "Monitor2" on the teach pendant.
	* Select "37 User Task" then "1 User Task Monitor"
* Run the socket server usertask:
	* Press the edit button (pen and paper, underneath numpad)
	* Navigate to the second row, and write in 100 to the "Prog." field.
	* Press the edit button again.
	* Navigate to the "Status" field. The message "Enable+ON to Start" should pop up.
	* Press the "ENABLE" and "ON" keys (top left and numpad 1) to start the usertask.
	* Press the "CLOSE" button (top right) to switch windows. (This button normally
	switches focus between windows, and when "ENABLE" and "CLOSE" are pressed, it closes
	the window in focus.)
	* Now the Robot Program window should be in focus, with our usertask running in the background.
### Starting the main loop
* Turn on the motors:
	* Press "ENABLE"+"MOTOR ON" (both in top left)
	* If it doesn't work, check the E-STOP button. You should hear an audible click when it works.
* Run the robot program:
	> [!WARNING]
	> The robot arm will move to a default pose upon execution. Clear the area!
	* Press "ENABLE"+"SHIFT"+"GO" to run the program. (ENABLE and SHIFT are in top left, GO is on the right)
	* Choose YES.
* Now the arm is ready for computer control. You can try the examples in [README](../README.md) from your computer.

## Stopping the robot
* To stop, press "ENABLE"+"STOP" (top left and top right) to stop the program.
* OPTIONAL: switch to the usertask window and stop the usertask. ("CLOSE" to switch, "ENABLE"+"STOP" to stop)
* OPTIONAL: press the E-STOP button on the pendant to shut off the motors.
* Turn the dial on the pendant and the key on the cabinet back into the teaching mode. (hand icon)
* Shut off both boxes in the cabinet.
