# Nachi Socket Lib
MATLAB and Python wrappers for tcp websocket-based control of the Nachi MZ07 robot arm.


## First-time Robot Configuration

The files in `src/nachi` need to be transferred to the robot and compiled.
The notes in [this document](docs/robot_configuration.md) may be helpful.

## Usage

### Robot Setup
Follow the instructions in [this document](docs/robot_operation.md) to prepare
the robot for computer control.

### MATLAB:
Place the ```Arm.m``` file in your current working directory.
```matlab
a = Arm %create arm object
a.ip = '127.0.0.1' %set ip
a.port = 10300 %set port
a.connect %connect
a.setxyz([400 0 500]) %set x,y,z coordinates to (400, 0, 500)
a.setpose([500 0 400 180 0 -120]) %you can also modify end effector angles
a.setjoints([0 80 0 0 0 0]) %or control each joint separately
reading = a.reading %get force sensor readings, arm's current coordinates, and joint angles
a.disconnect %close connection
```
### Python:
Place the ```arml.py``` file in your current working directory.
```python
import arml

a=arml.Arm('127.0.0.1', 10300) #create an Arm object, set the ip and port
a.connect() #connect
a.setxyz([400,0,500]) #set x,y,z coordinates to (400, 0, 500)
a.setpose([500, 0, 400, 180, 0, -120]) #you can also modify end effector angles
a.setjoints([0,80,0,0,0,0]) #or control each joint separately
reading = a.reading() #get force sensor readings, arm's current coordinates, and joint angles
a.disconnect() #close connection
```

## TODO:
- End effector angle readings are currently wrongly returned as 0.
