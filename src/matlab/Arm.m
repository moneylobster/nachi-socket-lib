%Arm class.
% A TCP socket wrapper for communicating and controlling a Nachi-Fujikoshi
% robot arm. The arm needs to be running a specific USERTASK for this class
% to function properly.
%
% Usage:
% create an Arm object
% configure ip and port variables
% call connect() to establish connection
classdef Arm < handle
    properties
        ip = 'localhost'
        port {mustBeNumeric} = 10300
        client
    end
    methods
        % connect to the given port and ip.
        function self=connect(self)
            self.client = tcpclient(self.ip,self.port);
            self.client.ByteOrder="big-endian";
        end
        % send a big-endian single-precision float to the robot.
        % Only supply numeric values as input to this function.
        function sendmsg(self, msg)
            arguments
                self
                msg {mustBeNumeric, mustBeReal, mustBeFinite}
            end
            write(self.client, msg, 'single');
        end
        % send a -9999 so that the robot closes and reopens its websocket.
        % (command to restart the server-side websocket)
        % to actually close the socket in MATLAB, clear the Arm object's
        % client variable. (or the object itself)
        function disconnect(self)
            self.sendmsg(-9999);
        end
        % send two values to the arm: first to indicate what to modify, and
        % the second to indicate the new value.
        % currently, possible ID values are:
        %   1 - X
        %   2 - Y
        %   3 - Z
        function modify(self, id, val)
            arguments
                self
                id {mustBeNumeric, mustBeReal, mustBeFinite}
                val {mustBeNumeric, mustBeReal, mustBeFinite}
            end
            self.sendmsg(id);
            self.sendmsg(val);
        end
        % set x coordinate of the end-effector.
        function setx(self, val)
            self.modify(1,val);
        end
        % set y coordinate of the end-effector.
        function sety(self, val)
            self.modify(2,val);
        end
        % set z coordinate of the end-effector.
        function setz(self, val)
            self.modify(3,val);
        end
        % set x,y,z coordinates of the end-effector.
        % valvec is a vector of target coordinates: [x, y, z]
        function setxyz(self, valvec)
            arguments
                self
                valvec {mustBeNumeric, mustBeReal, mustBeFinite}
            end
            self.sendmsg(5)
            self.sendmsg(valvec(1))
            self.sendmsg(valvec(2))
            self.sendmsg(valvec(3))
        end
        % set x,y,z coordinates and x,y,z angles of the end-effector.
        % valvec is a vector of target coordinates: [x, y, z, xang, yang, zang]
        function setpose(self, valvec)
            arguments
                self
                valvec {mustBeNumeric, mustBeReal, mustBeFinite}
            end
            self.sendmsg(6)
            self.sendmsg(valvec(1))
            self.sendmsg(valvec(2))
            self.sendmsg(valvec(3))
            self.sendmsg(valvec(4))
            self.sendmsg(valvec(5))
            self.sendmsg(valvec(6))
        end
		% set joint angles (radians) of the arm.
        % valvec is a vector denoting new [J1 J2 J3 J4 J5 J6] values for the arm.
        function setjoints(self, valvec)
            arguments
                self
                valvec {mustBeNumeric, mustBeReal, mustBeFinite}
            end
            self.sendmsg(7)
            self.sendmsg(valvec(1))
            self.sendmsg(valvec(2))
            self.sendmsg(valvec(3))
            self.sendmsg(valvec(4))
            self.sendmsg(valvec(5))
            self.sendmsg(valvec(6))
        end
        % ask for the force sensor forces Fx, Fy, Fz and torques Tx, Ty, Tz and the end effector pos x,y,z and arm joint angles.
		% blocks operations until arm returns a reply.
		% returns a vector [Fx Fy Fz Tx Ty Tz x y z J1 J2 J3 J4 J5 J6] where
		% 	Fx, Fy, Fz are the force sensor readings in x, y, z directions
		%	Tx, Ty, Tz are the force sensor's torque readings in x, y, z axes
		%	x, y, z are the arm's end-effector's current x, y, z coordinates
		%	J1, J2, J3, J4, J5, J6 are the arm's joint angles, in radians
        function res=reading(self)
            self.sendmsg(4); % a 4 indicates a reading request
            % if the blocking reading operation turns out to be a problem,
            % configureCallback can be used instead to define a callback
            % function that returns when enough data is available (6*4
            % bytes in this case)
            res=read(self.client,15,'single');
        end
    end
end
