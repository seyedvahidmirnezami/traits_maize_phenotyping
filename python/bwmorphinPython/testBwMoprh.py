import numpy as np
from bwmorph_thin import bwmorph_thin
import cv2
import numpy as np
import image
import scipy
from numpy import genfromtxt
#im = genfromtxt('asghar.csv', delimiter=',')
im = cv2.imread("C301B-1-07252017-2K7A2124.png")
print (type(im))
print (np.shape(im))
#print(im)
square = im
print (square)
print (np.flatnonzero(im))
'''square = np.zeros((7, 7), dtype=np.uint8)
square[1:-1, 2:-2] = 1
square[0,1] =  1'''
skel = bwmorph_thin(im)
print(skel)
skel2=skel.astype(np.uint8)
print(skel2)
#np.savetxt("foo.csv", skel2, delimiter=",")
