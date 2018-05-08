import numpy as np
import cv2
import matplotlib.pyplot as plt
import numpy.matlib

#lab_image = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
image = cv2.imread('C304B-4-07252017-2K7A2259.JPG',cv2.IMREAD_COLOR)
nrows, ncols, channels = image.shape
print ('nrows')
print (nrows)
print ('ncols')
print (ncols)
#print (image)
print ("****************************************************")
lab_he = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
#RGB=cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
gray1=cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
RGB=image
'''
plt.imshow(RGB)
plt.show()
plt.imshow(gray1)
plt.show()
'''
plt.imshow(lab_he)
plt.show()

print (lab_he)
print (lab_he.shape)
ab=lab_he[:,:,1:3]
print (ab.shape)
#print (type(ab))
ab = ab.reshape((nrows*ncols, 2))
#print (ab.shape)
#print (ab)
nColors=2
print ('*****')
criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,2, 20)

# Set flags (Just to avoid line break in the code)
flags = (cv2.KMEANS_RANDOM_CENTERS)
ab=np.float32(ab)
# Apply KMeans
_,cluster_idx,cluster_center = cv2.kmeans(ab,nColors,None,criteria,10,flags)

mean_cluster_value = np.average(cluster_center, axis=1)
print ('mean_cluster_value')
print (mean_cluster_value)

tmp = np.sort(mean_cluster_value)
idx = np.argsort(mean_cluster_value)
print ('tmp')
print (tmp)
print ('idx')
print (idx)
print('cluster_idx')
print(cluster_idx)
pixel_labels = cluster_idx.reshape(nrows,ncols)
print(pixel_labels.shape)
segmentedImages = np.zeros([nrows,ncols,3,nColors])
color = np.zeros([nrows,ncols,3,nColors])

rgb_label = np.repeat(pixel_labels[:, :, np.newaxis], 3, axis=2)
print (rgb_label.shape)

print('start')
for i in range(0,1):
    print (i)
    color = image
    plt.imshow(image)
    plt.show()
    print('ok')
    plt.imshow(color)
    plt.show()
    color[rgb_label !=i] = 0
    segmentedImages[:,:,:,i] = color
print('end')
newImage = segmentedImages[:,:,:,idx[1]]
print(newImage.shape)

#gray=cv2.cvtColor(segmentedImages[:,:,:,idx[1]],cv2.COLOR_BGR2GRAY)
plt.imshow(newImage)
print 
plt.show()
'''
print ("ret")

#print(ret.shape)
#print (ret)
print ("label")
print(cluster_idx.shape)
print (cluster_idx)
print ("cluster_center")
print (cluster_center.shape)
print (cluster_center)

cv2.imshow('image',lab_image)
cv2.waitKey(0)
cv2.destroyAllWindows()
'''