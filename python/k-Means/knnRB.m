% This function segments the foreground and the background of an image by
% identifying 2 clusters of colors: foreground and background. 
% Inputs: Standard RGB image.
% Output: RGB image with background removed.

% function x = knnRB(I,clust_num)
clust_num = 2;
% Converts the image into CIELAB format.
cform = makecform('srgb2lab');
lab_he = applycform(I,cform);

% Considers only the color values, removing intensity values;
ab = double(lab_he(:,:,2:3));

% Preallocating memory
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

% Determines the number of clusters
nColors = 2;

disp('Clustering Colors...')
% Performs k-means clustering, where k = nColors.
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
    'Replicates',2);

mean_cluster_value = mean(cluster_center,2);
[tmp, idx] = sort(mean_cluster_value);
% blue_cluster_num = idx(1);

% Labels each pixel with their specific color cluster.
pixel_labels = reshape(cluster_idx,nrows,ncols);

% Preallocates memory
segmented_images = cell(1,nColors);

% Creates mask of labeled pixels.
rgb_label = repmat(pixel_labels,[1 1 3]);

% Applies each mask on each pixel using their specific color
for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end


% Determines which cluster to pick. In this case, since the background is
% blue, the function would pick the image with the lower mean blue value.
% Then, the image is converted in to a grayscale image.
BW1 = rgb2gray(segmented_images{idx(clust_num)});
% if mean(mean(segmented_images{1}(:,:,3))) > mean(mean(segmented_images{2}(:,:,3)))
%     BW1 = rgb2gray(segmented_images{2});
% else
%     BW1 = rgb2gray(segmented_images{1});
% end

%

% Locates all the connected components and chooses only the largest
% connected component, which is the stalk.
CC = bwconncomp(BW1);
numPixels = cellfun(@numel,CC.PixelIdxList);
a = sort(numPixels(:));
I_gray = bwareaopen(BW1, max(a));

% Applies the mask of the stalk onto the original RGB image.
mask = repmat(I_gray,[1,1,3]);
% mask = repmat(BW1,[1,1,3]);
I(~mask)=0;

% Displays the segmented image.
% figure;imshow(I)
% title('Segmented Image')
x = I;