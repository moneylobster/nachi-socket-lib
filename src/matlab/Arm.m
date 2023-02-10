%Arm class.
% A TCP socket wrapper for communicating and controlling a Nachi-Fujikoshi
% robot arm. The arm needs to be running a specific USERTASK for this class
% to function properly.
%
% Usage:
% create an Arm object
% configure ip and port variables
% call connect() to establish connection
% call modify(id, val) to modify the arm's coordinates
% TODO:
% add some safety limits to the coordinate values
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
        % ask for the force sensor Fx, Fy, Fz and the end effector x,y,z.
        % blocks operations until arm returns a reply.
        % returns a vector: [Fx Fy Fz x y z]
        function res=reading(self)
            self.sendmsg(4); % a 4 indicates a reading request
            % if the blocking reading operation turns out to be a problem,
            % configureCallback can be used instead to define a callback
            % function that returns when enough data is available (6*4
            % bytes in this case)
            res=read(self.client,6,'single');
        end
    end
end