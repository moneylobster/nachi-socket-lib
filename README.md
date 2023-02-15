# Nachi Socket Lib
MATLAB and Python wrappers for tcp websocket-based control of the Nachi-Fujikoshi robot arm.

## Usage
### MATLAB:
```
a = Arm %create arm object
a.ip = '127.0.0.1' %set ip
a.port = 10300 %set port
a.connect %connect
a.setxyz([1 2 3]) %set x,y,z coordinates to (1,2,3)
reading = a.reading %get force sensor readings and arm's current coordinates
a.disconnect %close connection
```
### Python:
```
import arml

a=arml.Arm('127.0.0.1', 10300) #create an Arm object, set the ip and port
a.connect() #connect
a.setxyz([1,2,3]) #set x,y,z coordinates to (1,2,3)
reading = a.reading() #get force sensor readings and arm's current coordinates
a.disconnect() #close connection
```