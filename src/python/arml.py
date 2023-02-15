# -*- coding: utf-8 -*-
"""
arml - Python wrapper for tcp websocket-based control of the Nachi-Fujikoshi robot arm
Created on Wed Feb 15 12:41:54 2023

@author: Anil
"""

import socket
import struct

class Arm():
	
	def __init__(self, ip='localhost', port=10300):
		"""
		A TCP socket wrapper for communicating and controlling a Nachi-Fujikoshi
		robot arm. The arm needs to be running a specific USERTASK for this class
		to function properly.

		Parameters
		----------
		ip : IP address, optional
			IP address of the robot arm. The default is 'localhost'.
		port : int, optional
			The port of the arm's socket server. The default is 10300.

		Returns
		-------
		None.

		"""
		self.ip=ip
		self.port=port
	
	def connect(self):
		"""
		Connect to the stored port and ip.

		Returns
		-------
		None.

		"""
		self.client=socket.socket()
		self.client.connect((self.ip, self.port))
	
	def sendmsg(self, msg):
		"""
		Send a big-endian single-precision float to the robot over tcp.

		Parameters
		----------
		msg : real number
			value to be sent.

		Returns
		-------
		None.

		"""
		assert isinstance(msg, (int, float)), f"Non-real numeric input ({msg}) passed to sendmsg() function"
		
		self.client.send(struct.pack('>f',msg))
	
	def disconnect(self):
		"""
		Send a -9999 so that the robot closes and reopens its websocket.
		(command to restart the server-side websocket)
		Also closes the client-side socket in Python.

		Returns
		-------
		None.

		"""
		self.sendmsg(-9999)
		# sending a shutdown message seems to be unnecessary in this case'
		# see: https://stackoverflow.com/questions/409783/socket-shutdown-vs-socket-close
		# but if needed:
		# self.client.shutdown(socket.SHUT_RDWR)
		self.client.close() #close socket on our side
	
	def modify(self, id, val):
		"""
		Send two values to the arm: first to indicate what to modify, and
		the second to indicate the new value.
		Currently, possible ID values are:
			1 - X
			2 - Y
			3 - Z

		Parameters
		----------
		id : real number
			what parameter of the arm to modify.
			Currently, possible ID values are:
	          1 - X
	          2 - Y
	          3 - Z
		val : real number
			new value for the parameter.

		Returns
		-------
		None.

		"""
		assert isinstance(id, (int, float)), f"Non-real numeric input ({id}) passed to modify() function"
		assert isinstance(val, (int, float)), f"Non-real numeric input ({val}) passed to modify() function"
		
		self.sendmsg(id)
		self.sendmsg(val)
	
	def setx(self, val):
		"""
		set x coordinate of the end-effector.

		Parameters
		----------
		val : real number
			x coordinate of the end-effector.

		Returns
		-------
		None.

		"""
		self.modify(1, val)
	
	def sety(self, val):
		"""
		set y coordinate of the end-effector.

		Parameters
		----------
		val : real number
			y coordinate of the end-effector.

		Returns
		-------
		None.

		"""
		self.modify(2, val)
	
	def setz(self, val):
		"""
		set z coordinate of the end-effector.

		Parameters
		----------
		val : real number
			z coordinate of the end-effector.

		Returns
		-------
		None.

		"""
		self.modify(3, val)
	
	def setxyz(self, valvec):
		"""
		set x,y,z coordinates of the end-effector.

		Parameters
		----------
		valvec : array of real numbers
			new [x, y, z] values for the arm end-effector.

		Returns
		-------
		None.

		"""
		assert all(isinstance(val, (int, float)) for val in valvec), f"Non-real numeric input ({valvec}) passed to setxyz() function"
		
		self.setx(valvec[0])
		self.sety(valvec[1])
		self.setz(valvec[2])

	def reading(self):
		"""
		ask for the force sensor Fx, Fy, Fz and the end effector x,y,z.
		blocks operations until arm returns a reply.
		returns a vector: [Fx Fy Fz x y z]

		Returns
		-------
		array of 6 real numbers
			[Fx, Fy, Fz, x, y, z] where
			Fx, Fy, Fz are the force sensor readings in x, y, z directions
			x, y, z are the arm's end-effector's current x, y, z coordinates

		"""
		self.sendmsg(4)  # a 4 indicates a reading request
		resp=self.client.recv(24, socket.MSG_WAITALL)
		print(resp)
		return struct.unpack('>6f',resp)
		