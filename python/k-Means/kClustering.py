import numpy as np
import cv2
import matplotlib.pyplot as plt
import numpy.matlib


image = cv2.imread('C304B-4-07252017-2K7A2259.JPG',cv2.IMREAD_COLOR)
print(type(image))
nrows, ncols, channels = image.shape
print ('nrows')
print (nrows)
print ('ncols')
print (ncols)


lab_he = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
ab=lab_he[:,:,1:3]
print (ab.shape)
ab = ab.reshape((nrows*ncols, 2))
print (ab.shape)
nColors=2


criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,2, 20)
flags = (cv2.KMEANS_RANDOM_CENTERS)
ab=np.float32(ab)
_,cluster_idx,cluster_center = cv2.kmeans(ab,nColors,None,criteria,10,flags)
print (cluster_idx)
np.count_nonzero(cluster_idx)

mean_cluster_value = np.average(cluster_center, axis=1)
tmp = np.sort(mean_cluster_value)
idx = np.argsort(mean_cluster_value)

pixel_labels = cluster_idx.reshape(nrows,ncols)
print(pixel_labels.shape)
segmentedImages = np.zeros([nrows,ncols,3,nColors],dtype=np.uint8)
print(segmentedImages.shape)
rgb_label = np.repeat(pixel_labels[:, :, np.newaxis], 3, axis=2)
print(rgb_label.shape)

for i in range(0,2):
    print (i)
    color = image
    color[rgb_label !=i+1] = 0
    segmentedImages[:,:,:,i] = color

newImage = segmentedImages[:,:,:,0]
temp = newImage[:,:,0]

plt.imshow(newImage)
plt.show()

#im_gray = cv2.cvtColor(newImage, cv2.COLOR_BGR2GRAY )

#(thresh, im_bw) = cv2.threshold(im_gray, 0,1,cv2.THRESH_OTSU)


nb_components, output, stats, centroids =  cv2.connectedComponentsWithStats(temp, 8, cv2.CV_32S)
sizes = stats[:, -1]
max_label = 1
max_size = sizes[1]
for i in range(2, nb_components):
    if sizes[i] > max_size:
        max_label = i
        max_size = sizes[i]
img2 = np.zeros(output.shape)
img2[output == max_label] = 255
plt.imshow(img2)
plt.show()
cv2.imwrite('big.png',img2)
