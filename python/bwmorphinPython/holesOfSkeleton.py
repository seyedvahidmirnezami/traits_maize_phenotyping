import scipy.misc, scipy.ndimage

# Read the image
img = scipy.misc.imread("Skel.png")

# Retain only the skeleton
img[img!=255] = 0
img = img.astype(bool)

# Fill the holes
img2 = scipy.ndimage.binary_fill_holes(img)

# Compare the two, an image without cycles will have no holes
print "Cycles in image: ", ~(img == img2).all()

# As a test break the cycles
img3 = img.copy()
img3[0:200, 0:200] = 0
img4 = scipy.ndimage.binary_fill_holes(img3)

# Compare the two, an image without cycles will have no holes
print "Cycles in image: ", ~(img3 == img4).all()
