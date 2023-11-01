import arml
import numpy as np
from spatialmath import SE3
import matplotlib.pyplot as plt
import time

def circle_point(center, r, theta):
    '''
    generate point on a circle
    '''
    point=np.array([center[0]+r*np.cos(theta), center[1]+r*np.sin(theta), center[2], 1])
    return point

def circle_points(center, r, num_points):
    '''
    generate points of a circle
    '''
    points=np.array([circle_point(center,r,theta) for theta in np.arange(0,2*np.pi,2*np.pi/num_points)])
    return points

def rotate_circle(points, angles):
    return (SE3.RPY(*angles).data[0] @ points.T).T

def circle(center, r, rpy, num_points):
    theta=np.arange(0,2*np.pi,2*np.pi/num_points)
    points=np.vstack((r*np.cos(theta), r*np.sin(theta), np.zeros(num_points), np.ones(num_points)))
    points=SE3.RPY(rpy).data[0] @ points # rotate
    points=SE3.Trans(center).data[0] @ points # translate
    
    return points.T

def fig(pt):
    fig = plt.figure(figsize=(8, 8))
    ax = fig.add_subplot(111, projection='3d')
    
    ax.scatter(pt[:,0],pt[:,1],pt[:,2])
    
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.show()


CENTER=[500,0,400]
RADIUS=50
RPY=[0.5,0.5,0.2]
NUM_PTS=100

pts=circle(CENTER,RADIUS,RPY,NUM_PTS)

fig(pts)
input("start?")

arm=arml.Arm(ip="NRA2011.local")

arm.connect()
for pt in pts:
    #input("Send next?")
    arm.setxyz(pt[0:3])
    print("Sent.")
    #time.sleep(0.05)
arm.disconnect()
