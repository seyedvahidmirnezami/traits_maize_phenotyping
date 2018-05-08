import cv2 as cv
import sys
import numpy as np

if len(sys.argv) < 3:
    print ('usage: %s image.png K' % __file__)
    sys.exit(1)
print(sys.argv[1])
im = cv.imread(sys.argv[1], cv.IMREAD_COLOR)
K = int(sys.argv[2])

#
# Prepare the data for K-means.  Represent each pixel in the image as a 3D
# vector (each dimension corresponds to one of B,G,R color channel value).
# Create a column of such vectors -- it will be width*height tall, 1 wide
# and have a total 3 channels.
#
height, width, channels = im.shape
print (width)
print (height)
print (channels)
col = im.reshape(3,width*height)
print (col)
height2, width2 = col.shape
samples = np.zeros((height2, 1), dtype = "uint8")
print (samples)




#samples = cv.createMat(col.height, 1, cv.CV_32FC3)
#im.scale(col, samples)
labels = np.zeros((height2, 1), dtype = "uint8")
#
# Run 10 iterations of the K-means algorithm.
#
#crit = (CV_TERMCRIT_EPS +CV_TERMCRIT_ITER, 10, 1.0)
criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, 10, 1.0)
flags = cv.KMEANS_RANDOM_CENTERS
#cv.KMeans2(samples, K, labels, crit)

compactness,labels2,centers = cv.kmeans(samples,K,None,criteria,10,flags)
# Determine the center of each cluster.  The old OpenCV interface (C-style)
# doesn't seem to provide an easy way to get these directly, so we have to
# calculate them ourselves.
#
clusters = {}
for i in range(col.rows):
    b,g,r,_ = cv.Get1D(samples, i)
    lbl,_,_,_ = cv.Get1D(labels, i)
    try:
        clusters[lbl].append((b,g,r))
    except KeyError:
        clusters[lbl] = [ (b,g,r) ]
means = {}
for c in clusters:
    b,g,r = zip(*clusters[c])
    means[c] = (sum(b)/len(b), sum(g)/len(g), sum(r)/len(r), _)

#
# Reassign each pixel in the original image to the center of its corresponding
# cluster.
#
for i in range(col.rows):
    lbl,_,_,_ = cv.Get1D(labels, i)
    cv.Set1D(col, i, means[lbl])

interactive = False
if interactive:
    cv.ShowImage(__file__, im)
    cv.WaitKey(0)
else:
    cv.SaveImage('kmeans-%d.png' % K, im)